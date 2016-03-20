# preprocessing mongo_result.csv 
# build numeric matrix (action.csv) from mongo_result.csv
# Matlab can read action.csv
# another data format(good_action.csv) can be built from action.csv

import csv
from filter_interval_freq import *

user_list=[]

# row : [user_id, lecture(2-1), #run, +normal, +repeat, ...]
# example ['QKERAASD', 201, 21, 13, 2, ...]
# header_row=['id','lecture','run', '+normal', '+repeat','+if', '-normal', '-repeat','-if' ]


# input_arr : [QKERAASD, 2-1, +if~time, +repeat~time, run~time, ...] //variable size
# output : [0, 201, interval#(~5sec), interval#(~10sec), interval#(~30sec), interval#(~60sec),interval#(~300sec),interval#(~600sec)]
header_row=['id','lecture', '5#', '10#', '30#', '60#','300#','600#','long#']

interval_list = [5,10,30,60,300,600]
interval_list_len = len(interval_list)
def find_interval_index(input_interval):
    input_interval = input_interval/1000
    # print input_interval,
    for i in xrange(interval_list_len):
        if interval_list[i]>=input_interval:
            return i
    return (interval_list_len)

# # print find_interval_index(1448924811026-1448924808380)
# # print find_interval_index(1448924819017-1448924811026)
# print find_interval_index(2)
# print find_interval_index(6)
# print find_interval_index(12)
# print find_interval_index(42)
# print find_interval_index(74)
# print find_interval_index(123)
# print find_interval_index(522)
# print find_interval_index(5222)

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

    # # step 3
    ret=[user_idx, lecture_number]+[0]*7

    base_time = int(input_arr[3].split('~').pop())
    for i in xrange(4,len(input_arr)):
        new_time = int(input_arr[i].split('~').pop())
        add_index = 2+find_interval_index(new_time-base_time)
        ret[add_index] = ret[add_index]+1

        base_time = new_time


    # for x in input_arr[2:]:
    #     try:
    #         idx = header_row.index(x)
    #         ret[idx]=ret[idx]+1
    #     except ValueError:
    #         print x, 'is wrong'
    #         break

    return ret


# read mongo_result.csv and build action.csv
def generate_csv(mongo_csv, new_csv_path):

    # 1.start generating action.csv
    new_csv_path_file= open(new_csv_path, 'w')
    writer = csv.writer(new_csv_path_file, delimiter=",",lineterminator='\n')
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
        # len(row)==3 means [user_id, lecture#, action] (only one action list)
        if len(row)>3:
            csv_row = row_parse(row);
            writer.writerow(csv_row)


# main function
if __name__ == "__main__":
    mongo_result_file='../mongo/res_10_49.csv'
    new_csv_path='../data/interval_freq_10_49.csv'
    good_new_csv_path='../data/good_interval_freq_10_49.csv'
    
    # generate_csv(mongo_result_file, new_csv_path);

    # step 0) init filter
    my_filter=filtered_csv_generator(new_csv_path,good_new_csv_path);


    # step 1) build a filter
    my_filter.build_filter(new_csv_path);
    # step 2) write only data filtered
    my_filter.write_result_csv();
    