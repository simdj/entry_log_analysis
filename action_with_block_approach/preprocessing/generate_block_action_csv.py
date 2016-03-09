# preprocessing mongo_result.csv 
# build numeric matrix (action.csv) from mongo_result.csv
# Matlab can read action.csv
# another data format(good_action.csv) can be built from action.csv

import csv

header_row=['id','lecture','run', '+normal', '+repeat','+if', '-normal', '-repeat','-if' ]
user_list=[]

# row : [user_id, lecture(2-1), #run, +normal, +repeat, ...]
# example ['QKERAASD', 201, 21, 13, 2, ...]
def row_parse(input_arr):

    # step 1
    # mapping string to integer
    # 'QKERAASD' -> 0
    # 'QK23AASD' -> 1
    user_idx=-1;
    try:
        user_idx = user_list.index(input_arr[0])
    except ValueError:
        user_list.append(input_arr[0])
        user_idx = user_list.index(input_arr[0])

    # step 2
    # 2-1 -> 201
    # 12-10 -> 1210
    # lecture number -> integer
    lecture_number = int(input_arr[1].split('-')[0])*100+int(input_arr[1].split('-')[1])

    # step 3
    ret=[user_idx, lecture_number]+[0]*7
    for x in input_arr[2:]:
        try:
            idx = header_row.index(x)
            ret[idx]=ret[idx]+1
        except ValueError:
            print x, 'is wrong'
            break
    return ret


# read mongo_result.csv and build action.csv
def generate_csv(mongo_csv, block_action_csv_path):

    # 1.start generating action.csv
    block_action_csv_path_file= open(block_action_csv_path, 'w')
    writer = csv.writer(block_action_csv_path_file, delimiter=",",lineterminator='\n')
    # writing header
    writer.writerow(header_row)

    # 2.start reading action
    mongo_csv_file = open(mongo_csv,'rb');
    reader = csv.reader(mongo_csv_file)
    #skip the first two lines
    reader.next()       # MongoDB shell version: 3.0.7
    reader.next()       # connecting to: entry_3
    # writing row of action.csv
    for row in reader:
        # len(row)==2 means [user_id, lecture#] (no action list)
        if len(row)>2:
            csv_row = row_parse(row);
            writer.writerow(csv_row)


# main function
if __name__ == "__main__":
    mongo_result_file='../mongo/mongo_result_action_with_block.csv'
    block_action_csv_path='../data/raw_block_action.csv'
    generate_csv(mongo_result_file, block_action_csv_path);