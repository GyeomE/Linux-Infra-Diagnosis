#!/bin/bash
. function.sh

CODE [U-04] 패스워드 파일 보호

FILENAME1=/etc/shadow
FILENAME2=/etc/passwd


if [ -f $FILENAME ] ; then
	INFO "쉐도우 파일이 존재합니다."
	CHECK=$(cat $FILENAME2 | awk -F: '{print $2}' | grep -v 'x')
	if [ -z $CHECK ] ; then
		OK "쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우"
	else
		VULN "쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우"
	fi
else
	VULN "쉐도우 파일이 존재하지 않습니다."
fi

cat $RESULT

# result.log 파일의 내용을 읽고, 줄바꿈을 삭제하여 log_content 변수에 저장
log_content=$(cat result.log | tr -d '\n' | sed 's/"/\\"/g')
# 따옴표 이스케이프 처리

# printf를 사용하여 JSON 구조를 생성하고 result_U_01.json 파일에 저장
printf "{
    \"분류와 점검항목\": \"1. 계정관리 > 1.4 패스워드 파일 보호\",
    \"중요도\": \"상\",
    \"점검 내용\": \"시스템의 사용자 계정(root, 일반계정) 정보가 저장된 파일(예 /etc/passwd,/etc/shadow)에 사용자 계정 패스워드가 암호화되어 저장되어 있는지 점검\",
    \"점검 목적\": \"일부 오래된 시스템의 경우 /etc/passwd 파일에 패스워드가 평문으로 저장되므로 사용자 계정 패스워드가 암호화되어 저장되어 있는지 점검하여 비인가자의 패스워드 파일 접근 시에도 사용자 계정 패스워드가 안전하게 관리되고 있는지 확인하기 위함\",
    \"보안 위협\": \"사용자 계정 패스워드가 저장된 파일이 유출 또는 탈취 시 평문으로 저장된 패스워드 정보가 노출될 수 있음\",
    \"판단 기준\": \"양호 : 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우 취약 : 쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우\",
    \"조치 방법\": \"패스워드 암호화 저장∙관리 설정 적용\",
    \"검사 내용\": \"%s\"
}" "$log_content" > result_U_04.json
