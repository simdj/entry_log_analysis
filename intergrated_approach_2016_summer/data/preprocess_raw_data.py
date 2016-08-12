
# raw data -> feature (user,lecture,#run, #action, #action per run, time interval between runs)

# raw data format
#   key,id,lecture,run,+normal,+repeat,+if,-normal,-repeat,-if,5#,10#,30#,60#,300#,long# 
#   (after long#, there are action list)
#   example 
#       EjV5T1cU,1,409,1,4,1,2,0,0,0,7,0,0,0,0,0,+repeat~2016-06-10T12:41:20.494Z,+normal~2016-06-10T12:41:22.469Z,+if~2016-06-10T12:41:25.507Z,+normal~2016-06-10T12:41:27.830Z,+normal~2016-06-10T12:41:28.893Z,+if~2016-06-10T12:41:30.271Z,+normal~2016-06-10T12:41:31.112Z,run~2016-06-10T12:41:32.005Z
#       8YsGBsNy,2,409,2,4,1,3,1,0,1,8,2,1,0,0,0,+repeat~2016-06-11T00:13:31.645Z,+normal~2016-06-11T00:13:33.886Z,+if~2016-06-11T00:13:38.202Z,+normal~2016-06-11T00:13:52.914Z,+if~2016-06-11T00:13:56.556Z,+normal~2016-06-11T00:14:01.468Z,run~2016-06-11T00:14:02.

import csv
from datetime import datetime, timedelta


collecting_start_datetime = datetime(2016,6,13)
collecting_end_datetime = datetime(2016,6,27)

def find_time_interval_index(interval, time_border = [5,10,30,60]):
    idx=0
    for t in time_border:
        if interval<t:
            break
        idx+=1
    return idx

def get_interval_series_between_runs(event_arr):
    interval_series = []
    last_run_timestamp = datetime.strptime(event_arr[0].split('~').pop(),"%Y-%m-%dT%H:%M:%S.%fZ")
    for ev in event_arr:
        action_type, action_timestamp = ev.split('~')
        # run, 2016-06-10T12:41:20.494Z
        action_timestamp = datetime.strptime(action_timestamp,"%Y-%m-%dT%H:%M:%S.%fZ")


        if action_timestamp < collecting_start_datetime or action_timestamp > collecting_end_datetime:
            return False

        if action_type == 'run':
            interval = int((action_timestamp-last_run_timestamp).total_seconds())
            if interval < 1800:
                # more than half one hour -> exclude
                interval_series.append(interval)
            last_run_timestamp = action_timestamp
    return interval_series

def get_dist_of_interval_between_runs(event_arr, time_border = [5,10,30,60]):
    pass
    # time_row = [0]*(len(time_header))
    # last_run_timestamp = datetime.strptime(event_arr[0].split('~').pop(),"%Y-%m-%dT%H:%M:%S.%fZ")
    # for ev in event_arr:
    #     action_type, action_timestamp = ev.split('~')
    #     # run, 2016-06-10T12:41:20.494Z
    #     action_timestamp = datetime.strptime(action_timestamp,"%Y-%m-%dT%H:%M:%S.%fZ")
    #     if action_type == 'run':
    #         interval_bw_runs = int((action_timestamp-last_run_timestamp).total_seconds())
    #         # print interval_bw_runs, action_timestamp, last_run_timestamp
    #         time_row[find_time_interval_index(interval_bw_runs)]+=1
    #         last_run_timestamp = action_timestamp
    # return time_row

def get_num_action_series_between_runs(event_arr):
    num_action_series = []

    num_action=0
    for ev in event_arr:
        action_type, action_timestamp = ev.split('~')
        if action_type == 'run':
            num_action_series.append(num_action)
            num_action=0
        else:
            num_action+=1           
    return num_action_series





class clean_raw_data:
    def __init__(self
        ,raw_path='raw_data.csv'
        ,clean_raw_path='clean_raw_data.csv'
        ,meta_header = ['key','id','lecture']):
        # ,action_header = ['run', '+normal', '+repeat','+if','-normal', '-repeat','-if']
        # ,err_header = ['err_incomplete', 'err_without_ct', 'err_etc']
        # ,time_header = ['5#', '10#', '30#', '60#','300#','long#']):
        # ['key','id','lecture','run', '+normal', '+repeat','+if','-normal', '-repeat','-if','err_incomplete', 'err_without_ct', 'err_etc', '5#', '10#', '30#', '60#','300#','long#']
        
        self.raw_path = raw_path
        self.clean_raw_path = clean_raw_path
        # self.raw_header = meta_header+action_header+err_header+time_header
        self.raw_header = meta_header

        self.event_start_index = len(self.raw_header)
    
    def check_valid_timestamp(self,raw_row):
        event_arr=raw_row[self.event_start_index:]
        for ev in event_arr:
            action_type, action_timestamp = ev.split('~')
            action_timestamp = datetime.strptime(action_timestamp,"%Y-%m-%dT%H:%M:%S.%fZ")
            if action_timestamp < collecting_start_datetime or action_timestamp > collecting_end_datetime:
                return False
        return True
    
    def sort_by_timestamp(self,raw_row):
        event_arr=raw_row[self.event_start_index:]
        return sorted(event_arr, key=lambda action: action.split('~').pop())

    def preprocess_raw_row(self,raw_row):
        ret = raw_row[0:self.event_start_index]+self.sort_by_timestamp(raw_row)
        if self.check_valid_timestamp(ret):
            return ret
        else:
            return False

    def write_to_csv(self):
        # 1.start generating action.csv
        clean_raw_f= open(self.clean_raw_path, 'w')
        writer = csv.writer(clean_raw_f, delimiter=",",lineterminator='\n')
        # writing header
        writer.writerow(self.raw_header)

        # 2.start reading action
        raw_f = open(self.raw_path,'rb');
        reader = csv.reader(raw_f)
        # skip the first two lines
        reader.next()       # Header
        # reader.next()       # connecting to: entry_3
        # writing row of action.csv
        i=0
        for row in reader:
            # csv_row=self.extract_feature_from_raw_row(row)
            csv_row = self.preprocess_raw_row(row)
            if csv_row:
                writer.writerow(csv_row)
# clean raw data end



# ,meta_header = ['user','user2int','lec','#runs','#actions'] 
# ,time_header = ['~5','5~10','10~30','30~60','60~']
# new_header = meta_header+time_header

# time_border = [5,10,30,60]
# timedelta_arr=[timedelta(seconds=t) for t in time_border]

class feature_generator:
    def __init__(self
        ,clean_raw_path='clean_raw_data.csv'
        ,feature_path='feature.csv'
        # ,raw_header = ['key','id','lecture','run','+normal','+repeat','+if','-normal','-repeat','-if','5#','10#','30#','60#','300#','long#']
        ,meta_header = ['key','id','lecture']
        ,action_header = ['run', '+normal', '+repeat','+if','-normal', '-repeat','-if']
        ,err_header = ['err_incomplete', 'err_without_ct', 'err_etc']
        ,time_header = ['5#', '10#', '30#', '60#','300#','long#']
        # ,feature_header=['user','user2int','lec','#run','#action','err_incomplete', 'err_without_ct', 'err_etc','#action_per_run','interval_bw_run']):
        ,feature_header=['user','user2int','lec','#run','#action','err_incomplete', 'err_without_ct', 'err_etc']):
        
        self.clean_raw_path = clean_raw_path
        self.feature_path = feature_path
        # self.raw_header = meta_header+action_header+err_header+time_header
        self.err_header = err_header
        self.raw_header=meta_header

        self.feature_header=feature_header
        self.event_start_index = len(self.raw_header)
    
    
    def exclude_run_outlier(self,event_arr_sorted):
        ret = []
        run_flag = 0
        for ev in event_arr_sorted:
            action_type, action_timestamp = ev.split('~')
            if action_type=='run':
                if run_flag>=2:
                    continue
                else:
                    ret.append(ev)
                run_flag+=1
            else:
                run_flag=0
                ret.append(ev)
        return ret

    def count_specific_action(self,event_arr, action_type):
        action_count = 0
        for ev in event_arr:
            if ev.split('~')[0] ==action_type:
                action_count+=1
        return action_count

    def extract_feature_from_raw_row(self,raw_row, avg_actions_bw_run=True, avg_time_bw_run=True, action_series=False):
        # row : [user_id, user2int, lecture(2-1), #run, +normal, +repeat, ...]
        # example ['QKERAASD', 123, 201, 21, 13, 2, ...]
        # print raw_row[0:4]
        event_arr = raw_row[self.event_start_index:]
        event_arr = self.exclude_run_outlier(event_arr)
        

        run_count = self.count_specific_action(event_arr,'run')
        err_count = [self.count_specific_action(event_arr,err_type) for err_type in self.err_header]
        action_count = len(event_arr) - run_count - sum(err_count)

        # no run , no action 
        if run_count==0 or action_count==0:
            return False
        
        # num_action_series = get_num_action_series_between_runs(event_arr)
        # interval_series = get_interval_series_between_runs(event_arr)
        
        
        # ,feature_header=['user','user2int','lec','#run','#action','err_incomplete', 'err_without_ct', 'err_etc'
        # return raw_row[0:3]+[run_count, action_count]+[sum(num_action_series)/len(num_action_series), sum(interval_series)/len(interval_series)]

        
        ## return raw_row[0:4]+[action_count]+time_row+num_action_series
        ## return num_action_series

        return raw_row[0:3]+[run_count, action_count]+err_count

    def write_to_csv(self):
        # 1.start generating action.csv
        feature_f= open(self.feature_path, 'w')
        writer = csv.writer(feature_f, delimiter=",",lineterminator='\n')
        # writing header
        writer.writerow(self.feature_header)

        # 2.start reading action
        raw_f = open(self.clean_raw_path,'rb');
        reader = csv.reader(raw_f)
        # skip the first two lines
        reader.next()       # Header
        # reader.next()       # connecting to: entry_3
        # writing row of action.csv
        i=0
        for row in reader:
            csv_row=self.extract_feature_from_raw_row(row)
            if csv_row:
                writer.writerow(csv_row)
# feature generator end



# main function
if __name__ == "__main__":
    raw_data_path='raw_data.csv'
    clean_raw_data_path = 'clean_raw_data.csv'
    feature_data_path = 'feature.csv'
    
    clean_raw_data(raw_data_path, clean_raw_data_path).write_to_csv()


    feature_gen = feature_generator(clean_raw_data_path, feature_data_path)
    feature_gen.write_to_csv()