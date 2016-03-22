# preprocessing mongo_result.csv 
# build numeric matrix (action.csv) from mongo_result.csv
# Matlab can read action.csv
# another data format(good_action.csv) can be built from action.csv

import csv

header_row=['id','lecture','run', '+normal', '+repeat','+if', '-normal', '-repeat','-if' ]
user_list=[]
user_data={}
user_lecture_max = -1;
user_lecture_max_id = '';
# row : [user_id, lecture(2-1), #run, +normal, +repeat, ...]
# example ['QKERAASD', 201, 21, 13, 2, ...]
def row_parse(input_arr):
    global user_lecture_max, user_lecture_max_id
    # step 1
    # mapping string to integer
    # 'QKERAASD' -> 0
    # 'QK23AASD' -> 1
    user_idx=-1;
    try:
        user_idx = user_list.index(input_arr[0])
        user_data[user_idx]=user_data[user_idx]+1;
        if user_lecture_max < user_data[user_idx]:
            user_lecture_max = user_data[user_idx]
            user_lecture_max_id = input_arr[0]
    except ValueError:
        user_list.append(input_arr[0])
        user_idx = user_list.index(input_arr[0])
        user_data[user_idx]=1;
    

   

# read mongo_result.csv and build action.csv
def data_stats(mongo_csv):

    
    row_count =0;
    # 2.start reading action
    mongo_csv_file = open(mongo_csv,'rb');
    reader = csv.reader(mongo_csv_file)
    #skip the first two lines
    reader.next()       # MongoDB shell version: 3.0.7
    reader.next()       # connecting to: entry_3
    # writing row of action.csv
    for row in reader:
        if (len(row)>2):
            csv_row = row_parse(row);
            row_count = row_count+1;
    print(' row_count')
    print(row_count)

# main function
if __name__ == "__main__":
    mongo_result_file='../mongo/mongo_result_action_with_block.csv'
    data_stats(mongo_result_file);
    
    print('user #')
    print(len(user_data))

    print('user lecture max')
    print(user_lecture_max)
    print(user_lecture_max_id)
