#!/bin/bash

. function.sh


CODE [U-01] root 계정 원격 접속 제한

SERVICE1=telnet.socket
systemctl is-active $SERVICE1 >/dev/null 2>&1

if [ $? = 0 ]; then
    INFO "텔넷 서비스가 활성화 되어있습니다."
    VALUE1=$(cat /etc/securetty | grep "^pts" | wc -l)
    if [ $VALUE1 != 0 ] ; then
        VULN "root 직접 접속을 허용하고 원격 서비스를 사용하는 경우."
    else 
        OK "원격 서비스를 사용하지 않거나 사용 시 직접 접속을 차단한 경우."
    fi    
else
    OK "텔넷 서비스가 비활성화 되어있습니다."
fi

SERVICE2=sshd.service
systemctl is-active $SERVICE2 >/dev/null 2>&1
if [ $? = 0 ]; then
    INFO "SSH 서비스가 활성화 되어있습니다."
    VALUE2=$(cat /etc/ssh/sshd_config | grep 'PermitRootLogin yes' | awk {'print $2'} | sed '/the/d')
    if [ $VALUE2 == "yes" ] ; then
        VULN "root 직접 접속을 허용하고 원격 서비스를 사용하는 경우."
    else 
        OK "원격 서비스를 사용하지 않거나 사용 시 직접 접속을 차단한 경우."
    fi    
else
    OK "SSH 서비스가 비활성화 되어있습니다."
fi

cat $RESULT

log_content=$(cat result.log | tr -d '\n' | sed 's/"/\\"/g')

printf "{
    \"분류와 점검항목\": \"1. 계정관리 > 1.1 root 계정 원격접속 제한\",
    \"중요도\": \"상\",
    \"점검 내용\": \"시스템 정책에 root 계정의 원격터미널 접속차단 설정이 적용되어 있는지 점검\",
    \"점검 목적\": \"관리자계정 탈취로 인한 시스템 장악을 방지하기 위해 외부 비인가자의 root 계정 접근 시도를 원천적으로 차단하기 위함\",
    \"보안 위협\": \"root 계정은 운영체제의 모든기능을 설정 및 변경이 가능하여(프로세스, 커널변경 등) root 계정을 탈취하여 외부에서 원격을 이용한 시스템 장악 및 각종 공격으로(무작위 대입 공격) 인한 root 계정 사용 불가 위협\",
    \"판단 기준\": \"양호 : 원격 터미널 서비스를 사용하지 않거나, 사용 시 root 직접 접속을 차단한 경우 취약 : 원격 터미널 서비스 사용 시 root 직접 접속을 허용한 경우\",
    \"조치 방법\": \"원격 접속 시 root 계정으로 바로 접속 할 수 없도록 설정파일 수정\",
    \"검사 내용\": \"%s\"
}" "$log_content" > result_U_01.json
