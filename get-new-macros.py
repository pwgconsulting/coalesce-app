# Import variables from local file that store the target path for the macro files and the path of the data.yml file from which to extract the macro definitions
from paths import macroFileName,dataYMLPath
# Open the data.yml file, find macros and write them out to a file per macro
dataYML = open(dataYMLPath, 'r')
lines = dataYML.readlines()

macroName = ''
macroStartIdx = 0
macroEndIdx = 0
macrosDict = {}

for idx,line in enumerate(lines):
    if line.replace(' ','').find('%macro') > 0:
        macroStartIdx = idx
        macroName = line[line.find('macro')+6:line.find('(')]
    elif line.find('endmacro') > 0:
        macroEndIdx = idx
    macrosDict[macroName] = {}
    macrosDict[macroName]["StartIndex"] = macroStartIdx
    macrosDict[macroName]["EndIndex"] = macroEndIdx

del macrosDict['']

for macro in macrosDict.keys():
    macroFileName += macro + '.sql'
    macroFile = open(macroFileName,'w')
    idxStart = macrosDict[macro]["StartIndex"]
    idxEnd = macrosDict[macro]["EndIndex"]
    macroFile = open(macroFileName,'w')
    for idx,line in enumerate(lines):
        if idx >= idxStart and idx <= idxEnd:
            macroFile.writelines(line.replace('      ',''))
    macroFile.close()
    macroFileName = macroFileName.replace(macro + '.sql','')
