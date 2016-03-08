import json
import csv

json_file_path="./more_50_stage.json"
json_data={}

def read_json(filename) :
    f = open(filename, 'r')
    js = json.loads(f.read())
    f.close()
    return js

header_row=['id','lecture','run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone']


user_list=[]

# row : [user_id, lecture(2-1), #run, #addBlock, #insertBlock, ...]
# example ['QKERAASD', 201, 21, 13, 2, ...]
def row_parse(input_arr):

    # mapping string to integer
    # 'QKERAASD' -> 0
    # 'QK23AASD' -> 1
    user_idx=-1;
    try:
        user_idx = user_list.index(input_arr[0])
    except ValueError:
        user_list.append(input_arr[0])
        user_idx = user_list.index(input_arr[0])



    # 2-1 -> 201
    # 12-10 -> 1210
    # lecture number -> integer
    lecture_number = int(input_arr[1].split('-')[0])*100+int(input_arr[1].split('-')[1])

    ret=[user_idx, lecture_number]+[0]*7

    for x in input_arr[2:]:
        try:
            idx = header_row.index(x)
            ret[idx]=ret[idx]+1
        except ValueError:
            print x, 'is wrong'
            break
    return ret


# read json and write csv
def generate_csv(csv_name):
    global json_data
    with open(csv_name, 'w') as f:
        writer = csv.writer(f, delimiter=",",lineterminator='\n')

        # writing header
        writer.writerow(header_row)

        # writing data
        for k in json_data.keys():
            for row in json_data[k]:
                # len(row)==2 means [user_id, lecture#] (no action list)
                if len(row)>2:
                    csv_row = row_parse(row);
                    writer.writerow(csv_row)

# main function
if __name__ == "__main__":
    global json_file_path
    global json_data
    
    json_data = read_json(json_file_path)
    generate_csv('data.csv');