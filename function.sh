#!/bin/bash

LOG=check.log
RESULT=result.log
> $LOG
> $RESULT
 
BAR() {
echo "========================================================================" >> $RESULT
}
 
NOTICE() {
echo '[ OK ] : 정상'
echo '[WARN] : 비정상'
echo '[INFO] : Information 파일을 보고, 고객과 상의'
}
 
OK() {
echo -e ''"[ 양호 ] : $*"''
} >> $RESULT
 
WARN() {
echo -e ''"[ 경고 ] : $*"''
} >> $RESULT
 
INFO() {
echo -e ''"[ 정보 ] : $*"''
} >> $RESULT
 
CODE(){
echo -e ''$*''
} >> $RESULT
 
VULN(){
echo -e ''"[ 경고 ] : $*"''
} >> $RESULT
 
BLANKLINE(){
echo -e ''
} >> $RESULT
 
MAKE_LOGFILE(){
FILENAME=$(basename $(echo $0) | awk -F. '{print $1}').log
> "$FILENAME"
echo "$FILENAME"
}
 
SCRIPTNAME() {
basename $0 | awk -F. '{print $1}'
}
 
FindPattern(){
Filename=$1
FindPattern=$2
ReturnValue=$(egrep -v '^#|^$' $Filename | grep $FindPattern)
if [ -n "$ReturnValue" ] ; then
   echo -e $ReturnValue | awk -F= '{print $2}' # | sed -e 's/^[ \t]*//'
else
   echo None
fi
}
 
FindPattern2(){
Filename=$1
FindPattern=$2
FindPatternValue=$(egrep -v '^#|^$' $Filename | grep "^$FindPattern")
if [ -n "$FindPatternValue" ] ; then
   Return=$(echo $FindPatternValue | awk '{print $2}')
else
   Return=$(echo "None")
fi
echo $Return
}
 
IsFindPattern(){
if egrep -v '^#|^$' $1 | grep -q $2; then
   ReturnValue=$?
else
   ReturnValue=$?
fi
}
 
CheckPrintVulnerable(){
String1=$1
String2=$2
if [ $String1 = "vulnerbility" ] ; then
   VUL "$String2"
else
   OK "$String2"
fi
}
 
FILECONTENTCOPY() {
# $1 : source file
# $2 : desrination file
SrcFile=$1
DestFile=$2
egrep -v '^#|^$' $SrcFile >> $DestFile
}
 
ENHANCEDFILECONTENTCOPY() {
SrcFile=$1
DestFile=$2
SUBJECTFILENAME=$3
cat << EOF >> $DestFile
===============================================
$SUBJECTFILENAME 파일의 내용입니다.
===============================================
EOF
egrep -v '^#|^$' $SrcFile >> $DestFile
}

