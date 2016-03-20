# input_arr : [QKERAASD, 2-1, +if~time, +repeat~time, run~time, ...] //variable size
# get interval between if(or repeat) action and right after action
# output : [0, 201, interval#(~5sec), interval#(~10sec), interval#(~30sec), interval#(~60sec),interval#(~300sec),interval#(~600sec)]

import csv
from filter_interval_freq import *

user_list=[]



header_row=['id','lecture', '5#', '10#', '30#', '60#','300#','600#','long#']

interval_list = [5,10,30,60,300,600]
interval_list_len = len(interval_list)

def find_interval_index(input_interval):
    input_interval = input_interval/1000
    for i in xrange(interval_list_len):
        if interval_list[i]>=input_interval:
            return i
    return (interval_list_len)




def row_parse(input_arr, special_action):
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

    action_log_list = input_arr[2:]

    for i in xrange(len(action_log_list)):
        action = action_log_list[i]
        if action.split('~')[0]==special_action:
            base_time = int(action.split('~').pop())
            try:
                right_after_time = int(action_log_list[i+1].split('~').pop())
                add_index = 2+find_interval_index(right_after_time-base_time)
                ret[add_index] = ret[add_index]+1
            except:
                pass




    # base_time = int(input_arr[3].split('~').pop())
    # for i in xrange(4,len(input_arr)):
    #     new_time = int(input_arr[i].split('~').pop())
    

    #     base_time = new_time

    return ret


# read mongo_result.csv and build action.csv
def generate_csv(mongo_csv, new_csv_path, special_action):

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
            csv_row = row_parse(row, special_action);
            writer.writerow(csv_row)


# main function
if __name__ == "__main__":
    mongo_result_file='../mongo/res_10_49.csv'

    csv_path_if='../data/interval_freq_right_after_if_10_49.csv'
    good_csv_path_if='../data/good_interval_freq_right_after_if_10_49.csv'
    generate_csv(mongo_result_file, csv_path_if, '+if');
    
    csv_path_repeat='../data/interval_freq_right_after_repeat_10_49.csv'
    good_csv_path_repeat='../data/good_interval_freq_right_after_repeat_10_49.csv'
    generate_csv(mongo_result_file, csv_path_repeat, '+repeat');


    ##################


    # step 0) init filter
    # raw_file_path='../data/interval_freq.csv';
    # good_file_path='../data/good_interval_freq.csv';
    my_filter=filtered_csv_generator(csv_path_if,good_csv_path_if);
    my_filter.build_filter(csv_path_if);
    my_filter.write_result_csv();



    my_filter=filtered_csv_generator(csv_path_repeat,good_csv_path_repeat);
    my_filter.build_filter(csv_path_if);
    my_filter.write_result_csv();
    