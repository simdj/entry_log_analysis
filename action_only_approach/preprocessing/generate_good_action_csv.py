# #filter (user-stage)'s log when the action logs indicates success of the user in the stage 
# 1. remove the last stage information of each user
# 2. remove 2-13, 4-1 3-x, 5-x stage
# (optional) 3. remove log containing only run action

import csv;


def filtering(row):
    # 0. only select 200, 400 stage 
    # 1. remove the last stage information of each user
    # 2. remove 2-13 stage, 4-1 stage
    # (optional) 3. remove log containing only run action
    user_id = int(row[0]);
    stage_id= int(row[1]);

    ## condition 0
    if stage_id>300 and stage_id <400:
        return False;
    if stage_id>500:
        return False;

    ## condition 1        
    try:
        if stage_id==user_data_2[user_id]:
            return False;
    except:
        pass;
    
    try:
        if stage_id==user_data_4[user_id]:
            return False;
    except:
        pass;

    ## condition 2
    if stage_id==213 or stage_id==401:
        return False;

    # if sum(row[3:])==0:
    #     return False;

    return True; 

raw_csv_path = '../data/test_action_10_49.csv'
good_action_csv_path = '../data/test_good_action_10_49.csv'

header_row=['id','lecture','run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone']
user_list=[];

## contradiction is
######### sum(csv_row[3:]) == 0 means that action list consists of only run action. No add block, insert block,...
# if sum(csv_row[3:]) > 0:

# user_data_2[user_idx]=the last stage of the user (in course 2)
# user_data_4[user_idx]=the last stage of the user (in course 4)
user_data_2={}
user_data_4={}

raw_csv_file = open(raw_csv_path,'rb');
reader = csv.reader(raw_csv_file);

#skip first line
reader.next()
for row in reader:
    # build user_data2 and user_data_4 
    # in order to record the last stage in 2-x and 4-x of each user
    user_id = int(row[0]);
    stage_id = int(row[1]);
    
    if stage_id>200 and stage_id<300:
        try:
            if user_data_2[user_id] < stage_id:
                user_data_2[user_id] = stage_id;
        except:
            user_data_2[user_id] = stage_id;
    elif stage_id>400 and stage_id<500:
        try:
            if user_data_4[user_id] < stage_id:
                user_data_4[user_id] = stage_id;
        except:
            user_data_4[user_id] = stage_id;

raw_csv_file.close();


with open(good_action_csv_path, 'w') as f:
    writer = csv.writer(f, delimiter=",",lineterminator='\n');
    writer.writerow(header_row)

    raw_csv_file = open(raw_csv_path,'rb');
    reader = csv.reader(raw_csv_file);

    #skip the first line
    reader.next()
    for row in reader:
        if filtering(row)==True:
            # print row;
            writer.writerow(row);
    raw_csv_file.close()



