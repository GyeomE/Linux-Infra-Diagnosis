#!/bin/bash
. function.sh

CODE [U-03] 계정 잠금 임계값 설정

LOGFILE=LSC_03.sh
PAM_FILE1=/etc/pam.d/system-auth
PAM_MOD1=pam_faillock.so
PAM_MOD2=pam_tally2.so

CheckDenyValue() {
Value=$1
if [ $Value -le 5 ] ; then
    OK "계정 잠금 임계값이 5이하로 설정되어 있습니다."
else
    VULN "계정 잠금 임계값이 6이상으로 설정되어 있습니다."
fi
}

FIRSTLINE=$(egrep -v '^$|^#' $PAM_FILE1 | egrep "$PAM_MOD1|$PAM_MOD2" | grep '^auth')
SECONDLINE=$(echo $FIRSTLINE | cut -d' ' -f4-)

if [ -z "$SECONDLINE" ] ; then
    INFO "계정 잠금 임계값이 설정되어 있습니다."
else
    
    for i in $SECONDLINE
    do
        KEY=$(echo $i | awk -F= '{print $1}')
        VALUE=$(echo $i | awk -F= '{print $2}')
        case $KEY in
            'deny') CheckDenyValue $VALUE;;
            *) : ;;
        esac
    done
fi

INFO $LOGFILE "참고하세요."
cat << EOF > $LOGFILE
=======================================================
다음은 $PAM_FILE1 파일의 내용입니다.
=======================================================
EOF
FILECONTENTCOPY $PAM_FILE1 $LOGFILE

cat $RESULT

# result.log 파일의 내용을 읽고, 줄바꿈을 삭제하여 log_content 변수에 저장
log_content=$(cat result.log | tr -d '\n' | sed 's/"/\\"/g')
# 따옴표 이스케이프 처리

# printf를 사용하여 JSON 구조를 생성하고 result_U_01.json 파일에 저장
printf "{
    \"분류와 점검항목\": \"1. 계정관리 > 1.3 계정 잠금 임계값 설정\",
    \"중요도\": \"상\",
    \"점검 내용\": \"사용자 계정 로그인 실패 시 계정잠금 임계값이 설정되어 있는지 점검\",
    \"점검 목적\": \"계정탈취 목적의 무작위 대입 공격 시 해당 계정을 잠금하여 인증 요청에 응답하는 리소스 낭비를 차단하고 대입 공격으로 인한 비밀번호 노출 공격을 무력화하기 위함\",
    \"보안 위협\": \"패스워드 탈취 공격(무작위 대입 공격, 사전 대입 공격, 추측 공격 등)의 인증 요청에 대해 설정된 패스워드와 일치 할 때까지 지속적으로 응답하여 해당 계정의 패스워드가 유출 될 수 있음\",
    \"판단 기준\": \"양호 : 계정 잠금 임계값이 10회 이하의 값으로 설정되어 있는 경우 취약 : 계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우\",
    \"조치 방법\": \"계정 잠금 임계값을 10회 이하로 설정\",
    \"검사 내용\": \"%s\"
}" "$log_content" > result_U_03.json
