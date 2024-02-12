#!/bin/bash
. function.sh
>$RESULT
CHECK_ERROR=error.txt
>$CHECK_ERROR
NUM=1

for U_NUM in `seq 1 5`
do
	bash ./U-0$U_NUM.sh
	if [ $? -ne 0 ] ; then
		echo "U-$U_NUM 검사 오류" >> $CHECK_ERROR
	fi
done

# 모든 검사가 완료된 후 Python 스크립트 실행
python3 json_to_excel_new.py

echo "모든 검사 완료 및 Excel 파일 생성 완료"
