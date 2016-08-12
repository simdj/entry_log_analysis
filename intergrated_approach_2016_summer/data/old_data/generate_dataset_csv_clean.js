// usage
// mongo entry_2016 generate_dataset_csv.js > [mongo_result_#.csv]
// mongo entry_2016Summer generate_dataset_csv.js > data_all.csv
// mongo entry_2016Summer generate_dataset_csv_new.js > new_data_all.csv

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
///////////////////// multiple succeeding user exists !!!!!!!!!!!!!!!
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

COMMAND_TYPES={
	addThread: 101,
	// ...
	insertBlock:105,
	separateBlock:106,
	run:'run'

}
var csv_table ={}
meta_header = ['key','id','lecture']
action_header = ['run', '+normal', '+repeat','+if']
time_header = ['5#', '10#', '30#', '60#','300#','long#']
// header_row=['key','id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#']
header_row = meta_header.concat(action_header).concat(time_header)
time_limit_list=[5,10,30,60,300]
user2int_mapping={}
user_count=0


function traverse(o, block_id) {
	var ret=''
    for (i in o) {
		if(i=="id" && o[i]==block_id){
			// console.log(i,o[i],o.type)
			return o.type;
		}
        if (typeof(o[i])=="object" && o[i]!=null) {
            ret=traverse(o[i] ,block_id);
            if(ret!=""){
            	return ret;
            }	
        }
    }
    return ret;
}      

get_metadata_from_action = function(action, key){
	var action_metadata = action.data;
	for( index in action_metadata){
		var meta = action_metadata[index]
		if(meta.key==key){
			return meta.value;
		}
	}
	return '';
}

// input action : only run, insert, separate
// output : one item of set which is {run, +normal, -normal,+if, -if, +repeat, -repeat}
build_simple_action_log_obj = function(action){
	var action_log=''; // item to append to action_log_list
	var action_name = action.name
	var action_timestamp = action.timestamp

	var action_type=''
	switch(action_name){
		case COMMAND_TYPES.insertBlock:
			action_type='+'
			break
		case COMMAND_TYPES.separateBlock:
			action_type='-'
			break
		case COMMAND_TYPES.run:
			// return 'run~'+action_timestamp
			return {'action':'run~'+action_timestamp, 'created':new Date(action_timestamp) }
		default:
			return false
	}

	// block type parsing
	var block_id= get_metadata_from_action(action,"blockId");
	var code=get_metadata_from_action(action,"code")

	var block_type='';
	// get block type of action's target ( jr_go_wet, if_construction, repeat~~)
	if(block_id && code){
		block_type=traverse(JSON.parse(code),block_id)
	}else{
		console.log('FAIL building simple action log !!!!!!')
		return false
	}
	
	//return simple action log
	var simple_action_log_msg=''
	if(block_type.indexOf('if')>-1){
		simple_action_log_msg = action_type+'if~'+action_timestamp
	}else if(block_type.indexOf('repeat')>-1){
		simple_action_log_msg = action_type+'repeat~'+action_timestamp
	}else{
		simple_action_log_msg = action_type+'normal~'+action_timestamp
	}
	return {'action':simple_action_log_msg, 'created':new Date(action_timestamp) }
}



record_user_lecture_event = function(obj){
	//startstage : nothing to do
	if(obj.type=='startStage'){return false}

	var user = obj.key
	var stage = obj.stageId.split('-')[0]*100+obj.stageId.split('-')[1]*1
	
	if(!csv_table[user+','+stage]){
		//new!!
		csv_table[user+','+stage]={ user:user, lecture:stage, event_list:[], success:false, success_time:new Date()}
	}

	// recording part!!!

	//finishstage and success log
	if(obj.type=='finishStage' && obj.actions[0].name=='success'){
		csv_table[user+','+stage].success=true
		if(csv_table[user+','+stage].success_time > new Date(obj.actions[0].timestamp)){
			// record the first success time
			csv_table[user+','+stage].success_time = new Date(obj.actions[0].timestamp)
		}
		return true
	}

	//editStage
	if(obj.type=='editStage'){
		for(index in obj.actions){
			simple_action_log_obj = build_simple_action_log_obj(obj.actions[index])
			if(simple_action_log_obj){
				csv_table[user+','+stage].event_list.push(simple_action_log_obj)
			}
		}
		return true
	}

}


//printing start

print_compressed_csv_row_data = function(user, lecture, action_list){
	// user : zCZUHEOL
	// lecture : 407
	// action_list : ['+repeat~2016-06-13T12:06:43.115Z','+if~2016-06-13T12:06:44.969Z','+normal~2016-06-13T12:06:47.433Z','+normal~2016-06-13T12:06:51.440Z','run~2016-06-13T12:06:52.559Z']
	

	//lecture filter
	if(lecture==401){
		return false;
	}

	if(!user2int_mapping[user]){
		user_count++
		user2int_mapping[user]=user_count
	}
	var ret_meta = [user, user2int_mapping[user],lecture]
	var ret_action = Array(action_header.length).fill(0); 
	var ret_time = Array(time_header.length).fill(0); 
	

	base_time = ''
	for(i in action_list){
		col_name = action_list[i].split('~')[0]
		col_index = action_header.indexOf(col_name)
		if(col_index<0){
			continue
		}

		//action count
		ret_action[col_index]++
		
		//time interval count
		if(!base_time){
			base_time = new Date(action_list[i].split('~').pop())
		}else{
			diff = (new Date(action_list[i].split('~').pop()) - base_time)/1000
			time_limit_index = time_limit_list.map(function(x){return x>diff}).indexOf(true)
			time_limit_index==-1 ? ret_time[ret_time.length-1]++ : ret_time[time_limit_index]++
			base_time = new Date(action_list[i].split('~').pop())
		}

	}
	// output!!
	print(ret_meta.concat(ret_action).concat(ret_time))
}

print_csv_table = function(){
	for(index in csv_table){
		var row = csv_table[index]
		if(row.success){
			//filtering with the first success time

			user = row.user
			lecture = row.lecture
			event_list = row.event_list
			first_success_time = row.success_time

			//filter event_list by first_success_time
			filtered_event_list = event_list.filter(function(event_obj){return event_obj.created<=first_success_time})
			action_list = []
			filtered_event_list.forEach(function(event_obj){
				action_list.push(event_obj.action)
			});
			// filtered_event_list.forEach(function(event_obj){action_list.push.apply(action_list,event_obj.actions)});

			action_list.sort(function(a,b){
				return a.split('~').pop()*1-b.split('~').pop()*1}
			)
			print_compressed_csv_row_data(user, lecture, action_list)
		}
	}
}




// // total
cursor = db.getCollection('raw_activities').find(
// cursor = db.getCollection('raw_log').find(
	// { "stageId": { $in: [ /^4-10/i ] } }

	// {"stageId":"4-7","key":"zCZUHEOL"},
	// ,
	// {"stageId":"4-10"},
	{ 
		// "stageId": "4-10"
		"stageId": { $in: [ /^4-/ ] } 
		// , "created": {
		// 	$gte : ISODate("2016-06-13T00:00:00.000Z"),
		// 	$lt: ISODate("2016-06-20T00:00:00.000Z")
		// }
	},
	{
		key:1, "stageId":1, "type":1,
		"actions.name":1,
		"actions.data.key":1, "actions.data.value":1,
		"actions.timestamp" : 1,
		
		// users who successed multiple times exist
		"created":1, 
		_id:0
    }
)



// // only 409 lecture
// cursor = db.getCollection('lecture409').find(
// 	// {key:"kMtX5wrX"}, //log created times are dirty
// 	// {key : "dQ33x2cq"}, //created timestamp of stage are dirty
// 	{},
// 	{
// 		key:1, "stageId":1, "type":1,
// 		"actions.name":1,
// 		"actions.data.key":1, "actions.data.value":1,
// 		"actions.timestamp" : 1,
		
// 		// users who successed multiple times exist
// 		"created":1, 
// 		_id:0
//     }
// )

while (cursor.hasNext()) {
  	record_user_lecture_event(cursor.next())
}

print(header_row)
print_csv_table()

