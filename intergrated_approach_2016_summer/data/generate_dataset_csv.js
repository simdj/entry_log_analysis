// usage
// mongo entry_2016 generate_dataset_csv.js > [mongo_result_#.csv]
COMMAND_TYPES={
	addThread: 101,
	// ...
	insertBlock:105,
	separateBlock:106,
	run:'run'

}
var csv_table ={}

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
build_simple_action_log = function(action){
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
			return 'run~'+action_timestamp
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
	if(block_type.indexOf('if')>-1){
		return action_type+'if~'+action_timestamp
	}else if(block_type.indexOf('repeat')>-1){
		return action_type+'repeat~'+action_timestamp
	}else{
		return action_type+'normal~'+action_timestamp
	}
}



fill_csv_table = function(obj){
	//startstage : nothing to do
	if(obj.type=='startStage'){return false}
	var user = obj.key
	var stage = obj.stageId.split('-')[0]*100+obj.stageId.split('-')[1]*1
	
	if(!csv_table[user+','+stage]){
		//new!!
		csv_table[user+','+stage]={ user:user, lecture:stage, action_list:[], success:false}
	}

	//finishstage and success log
	if(obj.type=='finishStage' && obj.actions[0].name=='success'){
		csv_table[user+','+stage].success=true
		return true
	}

	//editStage
	if(obj.type=='editStage'){
		for(index in obj.actions){
			simple_action_log = build_simple_action_log(obj.actions[index])
			if(simple_action_log){
				csv_table[user+','+stage].action_list.push(simple_action_log)
			}
		}
		return true
	}

}

header_row=['id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#']
time_limit_list=[5,10,30,60,300]
user2int_mapping={}
user_count=0
print_compressed_csv_row_data = function(user, lecture, action_list){
	// zCZUHEOL
	// 407
	// +repeat~2016-06-13T12:06:43.115Z,+if~2016-06-13T12:06:44.969Z,+normal~2016-06-13T12:06:47.433Z,+normal~2016-06-13T12:06:51.440Z,run~2016-06-13T12:06:52.559Z
	// a=['+repeat~2016-06-13T12:06:43.115Z','+if~2016-06-13T12:06:44.969Z','+normal~2016-06-13T12:06:47.433Z','+normal~2016-06-13T12:06:51.440Z','run~2016-06-13T12:06:52.559Z']
	// ret = [user,lecture].concat(new Array(header_row.length-2).fill(0))
	
	if(!user2int_mapping[user]){
		user_count++
		user2int_mapping[user]=user_count
	}
	var ret = [user2int_mapping[user],lecture]
	// .concat(new Array(header_row.length-2).fill(0))
	for(var i=0;i<header_row.length-2;i++){
		ret.push(0)
	}
	base_time = ''
	for(i in action_list){
		col_name = action_list[i].split('~')[0]
		col_index = header_row.indexOf(col_name)
		if(col_index<0){
			continue
		}

		//action count
		ret[col_index]++
		
		//time interval count
		if(!base_time){
			base_time = new Date(action_list[i].split('~').pop())
		}else{
			diff = (new Date(action_list[i].split('~').pop()) - base_time)/1000
			time_limit_index = time_limit_list.map(function(x){return x>diff}).indexOf(true)
			time_limit_index==-1 ? ret[ret.length-1]++ : ret[6+time_limit_index]++
			base_time = new Date(action_list[i].split('~').pop())
		}

	}

	//lecture filter
	if(lecture!=401){
		print(ret)
	}


}

print_csv_table = function(){
	for(index in csv_table){
		var row = csv_table[index]
		if(row.success){
			row.action_list.sort(function(a,b){
				return a.split('~').pop()*1-b.split('~').pop()*1}
			)
			print_compressed_csv_row_data(row.user, row.lecture, row.action_list)
			 // print([row.user, row.lecture].concat(row.action_list))
		}
	}
}




cursor = db.getCollection('raw_log').find(
	// { "stageId": { $in: [ /^4-10/i ] } }

	// {"stageId":"4-7","key":"zCZUHEOL"},
	// ,
	{ "stageId": { $in: [ /^4-/ ] } },
	{
		key:1, "stageId":1, "type":1,
		"actions.name":1,
		"actions.data.key":1, "actions.data.value":1,
		"actions.timestamp" : 1,
		_id:0
    }
)
while (cursor.hasNext()) {
  	fill_csv_table(cursor.next())
}

print(header_row)
print_csv_table()