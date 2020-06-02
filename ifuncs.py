#import sys;f=open(sys.argv[1],'r')
import sys
def replace(db=""):

    srcDst={"docker-compose.temp.yml":"docker-compose.yml"}
    if db!="":
        srcDst={"docker-compose."+db+".temp.yml":"docker-compose.yml"}

    for src in srcDst.keys():
        f=open(src,'r')
        
        #
        #import configparser python 2.x
        if sys.version[0]=="2":
            import ConfigParser as cp
        else:
            import configparser as cp        

        conf=cp.ConfigParser()
        conf.read("env")
        content=f.read()
        for section in conf.sections():
            for option in conf.options(section):
                content=content.replace("#"+option,conf.get(section,option))

        f.close()
        with open(srcDst[src],"w") as f:
            f.write(content)

#
