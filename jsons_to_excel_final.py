import json
import pandas as pd

def jsons_to_excel(json_file_paths, excel_file_path):
    """
    주어진 JSON 파일들로부터 데이터를 읽어서 하나의 DataFrame으로 병합한 후,
    이를 Excel 파일로 저장하는 함수입니다.

    Parameters:
    - json_file_paths: JSON 파일 경로의 리스트
    - excel_file_path: 결과로 저장될 Excel 파일의 경로
    """
    dfs = []  # DataFrame을 저장할 리스트
    for json_file_path in json_file_paths:
        with open(json_file_path, 'r', encoding='utf-8') as file:
            try:
                # 파일로부터 JSON 데이터를 로드
                data = json.load(file)
                # 로드된 데이터로부터 DataFrame 생성 후 리스트에 추가
                dfs.append(pd.DataFrame([data]))
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

# 사용 예시
json_file_paths = [f'./result_U_0{i}.json' for i in range(1, 6)]
excel_file_path = 'result_U_01_to_05.xlsx'
jsons_to_excel(json_file_paths, excel_file_path)
