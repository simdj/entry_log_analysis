# GOAL : preprocessing mongo_intergrated_result.csv 
#        =build numeric matrix (intergrated_data.csv) from mongo_intergrated_result.csv
#       Matlab can read intergrated_data.csv

# What to do
# 1.transform lecture_str to integer (4-2 --> 402)
# 2.only filter course 4
# 3.transform count vector of time and block type

# Specification 
# [mongo_intergrated_result.csv]
# Example row
# pbN0ueeq,4-1,+normal~1448908405517,+normal~1448908406848,run~1448908407548,run~1448908437260,....

# [intergrated_data.csv]
# row : [user_id, lecture(2-1), #run, #+normal, #+repeat, '5#', '10#', '30#', '60#','300#','long#']
# example ['QKERAASD', 201, 21, 13, 2, ...]

header_row=['id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#']

import csv

user_list=[]

interval_list = [5,10,30,60,300]
interval_list_len = len(interval_list)
def find_interval_index(input_interval):
    input_interval = input_interval/1000
    for i in xrange(interval_list_len):
        if interval_list[i]>=input_interval:
            return i
    return (interval_list_len)

# print find_interval_index(1448924811026-1448924808380)

def fill_user_list(input_arr):
    # step 1
    # mapping user_id_string to integer
    # 'QKERAASD' -> 0
    # 'QK23AASD' -> 1
    user_idx=-1;
    try:
        user_idx = user_list.index(input_arr[0])
    except ValueError:
        user_list.append(input_arr[0])
        user_idx = user_list.index(input_arr[0])

    
    


# read mongo_result.csv and build action.csv
def generate_csv(mongo_csv, new_csv):

    # 1.get ready to write intergared_data.csv
    new_csv_file= open(new_csv, 'w')
    writer = csv.writer(new_csv_file, delimiter=",",lineterminator='\n')
    # 1-1.writing header
    # writer.writerow(header_row)

    # 2.get ready to read mongo_intergrated_result.csv
    mongo_csv_file = open(mongo_csv,'rb');
    reader = csv.reader(mongo_csv_file)
    # 2-1.skip the first two lines
    reader.next()       # MongoDB shell version: 3.0.7
    reader.next()       # connecting to: entry_3
    

    # 3. parse and write row 
    for row in reader:
        

        csv_row=fill_user_list(row)
        
        # writer.writerow(csv_row)
    # print(user_list)
    for i in xrange(len(user_list)):
        writer.writerow([i, user_list[i]])


# main function
if __name__ == "__main__":
    mongo_csv='mongo_intergrated_result.csv'
    new_csv='user_list.csv'
    generate_csv(mongo_csv, new_csv)