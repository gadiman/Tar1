import ceylon.file {
    forEachLine,
    Resource,
    File,
    parsePath,
    lines,
    Directory,
    Visitor,
    home
}

shared void readFile(String filePath) {
    Resource resource = parsePath(filePath).resource;
    // Resource has 4 subtypes: File | Directory | Link | Nil
    // We have to resolve the type.
    if (is File resource) {
        variable String textOfFile="";
        variable String dict = resource.directory.string;

        forEachLine(resource, (String line) {

            {String*} firstWords = line.split();
            String? firstWord = firstWords.first;
            print(firstWord);

            switch (firstWord)
            case ("add") {
                textOfFile += addFun();
                print(textOfFile);
            }
            case ("sub") {
                textOfFile += subFun();
            }
            case ("neg") {
                textOfFile += negFun();
            }
            case ("and") {
                textOfFile += andFun();
            }
            case ("not") {
                textOfFile += notFun();
            }
            case ("or") {
                textOfFile += orFun();
            }
            case ("eq") {
                textOfFile += eqFun();
            }
            case ("lt") {
                textOfFile += ltFun();
            }
            case ("gt") {
                textOfFile += gtFun();
            }
            case ("pop") {
                //textOfFile += popFun();
            }
            case ("push") {
                //textOfFile += pushFun();
            }
            else {  }
        });

        String pathForAsmFile = changeNameOfSuffix(resource.name,dict);
        writeFileAsm(pathForAsmFile,textOfFile);
        print(textOfFile);
        textOfFile ="";


    }



}

String changeNameOfSuffix(String name,String dict){
    value index =name.indexOf(".");
    variable String newName = name.substring(0,index);
    newName+=".asm";
    return dict+"\\" +newName;
}

String addFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="M=M+D\n";

    return tmp;
}

String subFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="M=M-D\n";
    return tmp;
}

String negFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="M=-D\n";
    return tmp;
}

String andFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="M=M&D\n";
    return tmp;
}

String notFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="M=!D\n";
    return tmp;

}

String orFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="M=M|D\n";

    return tmp;
}


variable Integer counter = 0;//For lables

String eqFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M-D\n"; //arg1-arg2
    tmp+="IF_TRUE"+counter.string+"\n"; //firs lable
    tmp+="D;JEQ\n"; //jump if equals
    tmp+="D=0\n"; //not equals so D=false
    tmp+="@SP\n";
    tmp+="A=M-1\n";
    tmp+="A=A-1\n";
    tmp+="M=D\n";
    tmp+="IF_FALSE"+counter.string+"\n"; //second lable
    tmp+="0;JMP\n"; //jump to second lable
    tmp+="(IF_TRUE" + counter.string + ")\n";
    tmp+="D=-1\n";
    tmp+="@SP\n";
    tmp+="A=M-1\n";
    tmp+="A=A-1\n";
    tmp+="M=D\n";
    tmp+="(IF_FALSE" + counter.string + ")\n";
    tmp+="@SP\n";
    tmp+="M=M-1\n";

    return tmp;
}

String ltFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M-D\n";
    tmp+="IF_TRUE"+counter.string+"\n";
    tmp+="D;JLT\n";
    tmp+="D=0\n";
    tmp+="@SP\n";
    tmp+="A=M-1\n";
    tmp+="A=A-1\n";
    tmp+="M=D\n";
    tmp+="IF_FALSE"+counter.string+"\n";
    tmp+="0;JMP\n";
    tmp+="(IF_TRUE" + counter.string + ")\n";
    tmp+="D=-1\n";
    tmp+="@SP\n";
    tmp+="A=M-1\n";
    tmp+="A=A-1\n";
    tmp+="M=D\n";
    tmp+="(IF_FALSE" + counter.string + ")\n";
    tmp+="@SP\n";
    tmp+="M=M-1\n";

    return tmp;
}

String gtFun(){
    variable String tmp="";
    tmp+="@SP\n";
    tmp+="A=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M\n";
    tmp+="A=A-1\n";
    tmp+="D=M-D\n";
    tmp+="IF_TRUE"+counter.string+"\n";
    tmp+="D;JGT\n";
    tmp+="D=0\n";
    tmp+="@SP\n";
    tmp+="A=M-1\n";
    tmp+="A=A-1\n";
    tmp+="M=D\n";
    tmp+="IF_FALSE"+counter.string+"\n";
    tmp+="0;JMP\n";
    tmp+="(IF_TRUE" + counter.string + ")\n";
    tmp+="D=-1\n";
    tmp+="@SP\n";
    tmp+="A=M-1\n";
    tmp+="A=A-1\n";
    tmp+="M=D\n";
    tmp+="(IF_FALSE" + counter.string + ")\n";
    tmp+="@SP\n";
    tmp+="M=M-1\n";

    return tmp;

}

//String popFun(){}

//String pushFun(){}




