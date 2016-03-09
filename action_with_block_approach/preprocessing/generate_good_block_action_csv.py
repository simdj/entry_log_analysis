# #filter (user-stage)'s log when the action logs indicates success of the user in the stage 
# 1. remove the last stage information of each user
# 2. remove 2-13, 4-1 3-x, 5-x stage
# (optional) 3. remove log containing only run action

import csv;

class block_action_csv_generator():
    raw_file_path='';
    good_file_path='';

    header_row=['id','lecture','run', '+normal', '+repeat','+if', '-normal', '-repeat','-if' ]

    user_data_2={}; # self.user_data_2[user_idx]=the last stage of the user (in course 2);
    user_data_4={}; # self.user_data_4[user_idx]=the last stage of the user (in course 4);

    def __init__(self, raw_file_path, good_file_path):
        self.raw_file_path=raw_file_path;
        self.good_file_path=good_file_path;



    def build_filter(self,csv_path):
        f = open(csv_path,'rb');
        reader = csv.reader(f);

        #skip first line
        reader.next();
        for row in reader:
            # build user_data2 and user_data_4 
            # in order to record the last stage in 2-x and 4-x of each user
            user_id = int(row[0]);
            stage_id = int(row[1]);
            
            if stage_id>200 and stage_id<300:
                try:
                    if self.user_data_2[user_id] < stage_id:
                        self.user_data_2[user_id] = stage_id;
                except:
                    self.user_data_2[user_id] = stage_id;
            elif stage_id>400 and stage_id<500:
                try:
                    if self.user_data_4[user_id] < stage_id:
                        self.user_data_4[user_id] = stage_id;
                except:
                    self.user_data_4[user_id] = stage_id;
        f.close();


    def filtering(self,row):
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
            if stage_id==self.user_data_2[user_id]:
                return False;
        except:
            pass;
        
        try:
            if stage_id==self.user_data_4[user_id]:
                return False;
        except:
            pass;

        ## condition 2
        if stage_id==213 or stage_id==401:
            return False;

        # if sum(row[3:])==0:
        #     return False;

        return True; 

    def write_result_csv(self):
        # step 1) get ready to read 
        csv_to_read = open(self.raw_file_path,'rb');
        reader = csv.reader(csv_to_read);
        reader.next(); #skip the first line

        # step 2) get ready to write
        csv_to_write = open(self.good_file_path, 'w');
        writer = csv.writer(csv_to_write, delimiter=",",lineterminator='\n');
        writer.writerow(self.header_row);

        # step 3) write only filtered data 
        for row in reader:
            if self.filtering(row)==True:
                # print row;
                writer.writerow(row);
        csv_to_read.close();

        return True;
# end block_action_csv_generator


if __name__ == "__main__":
    # step 0) init filter
    raw_file_path='../data/raw_block_action.csv';
    good_file_path='../data/good_block_action.csv';
    my_filter=block_action_csv_generator(raw_file_path,good_file_path);


    # step 1) build a filter
    my_filter.build_filter(raw_file_path);
    # step 2) write only data filtered
    my_filter.write_result_csv();
    