import json
import pandas as pd

# JSON 파일 경로 리스트 생성
json_file_paths = [f'./result_U_0{i}.json' for i in range(1, 6)]
excel_file_path = 'combined_results.xlsx'

# 모든 JSON 파일로부터 데이터를 읽어서 DataFrame 리스트에 저장
dfs = []  # DataFrame을 저장할 리스트
for json_file_path in json_file_paths:
    with open(json_file_path, 'r', encoding='utf-8') as file:
        try:
            # 파일로부터 JSON 데이터를 로드
            data = json.load(file)
            # "검사 내용"에 대한 "점검 결과" 값을 설정
            data['점검 결과'] = "취약" if "경고" in data.get("검사 내용", "") else "양호"
            # 로드된 데이터로부터 DataFrame 생성 후 리스트에 추가
            dfs.append(pd.json_normalize(data))
        except json.JSONDecodeError as e:
            print(f"{json_file_path}에서 JSON 파싱 오류가 발생했습니다: {e}")

# 모든 DataFrame을 하나로 병합
if dfs:
    combined_df = pd.concat(dfs, ignore_index=True)
    # 병합된 DataFrame을 Excel 파일로 저장
    combined_df.to_excel(excel_file_path, index=False, engine='openpyxl')
    print(f"'{excel_file_path}' 파일로 종합된 데이터가 성공적으로 저장되었습니다.")
else:
    print("병합할 데이터가 없습니다.")

