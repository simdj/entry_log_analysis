// usage
// mongo entry_3 mongo_get_every_data_2015.js > [mongo_result_#.csv]

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



action_list_to_extract=['insertBlock','seperateBlock','run']

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

	var action_name = action.name.valueOf(); 
	var action_timestamp = action.timestamp.valueOf()

	if(action_name=='run'){
		return 'run~'+action_timestamp
	}

	// from now on  insert, separate
	var action_type='+'
	if(action_name=='seperateBlock'){
		action_type='-'
	}

	var block_id= get_metadata_from_action(action,"blockId");
	var code=get_metadata_from_action(action,"code")

	var block_type='';
	// get block type of action's target ( jr_go_wet, if_construction, repeat~~)
	if(block_id && code){
		block_type=traverse(JSON.parse(code),block_id)
	}else{
		return 'FAIL building simple action log !!!!!!'
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

//extract ( run, +normal, -normal,+if, -if, +repeat, -repeat)
parsing_stages_json = function(stage){ 
	action_log_list=[]
	
	for(var index=0;index<stage.actions.length;index++){
		
		var action = stage.actions[index]; // list of action's metadata
		var action_name = action.name.valueOf(); 
		if(action_list_to_extract.indexOf(action_name)>-1){
			// only insert, separate, run 
			// exclude other actions (move, destroy, add )
			action_log_list.push(build_simple_action_log(action))
		}
		
	}
	// return [stage.stageId.valueOf()].concat( stage.actions.map(extracting_action_and_block) );
	// [2-1] [+normal~ts,+normal~ts,+if~ts,+normal~ts,+repeat~ts,+normal~ts,run~ts]
	return [stage.stageId.valueOf()].concat( action_log_list );
}


parsing_user_json = function(user_json){
	stage_result = user_json.stages.map(parsing_stages_json)
	for(var i=0;i<stage_result.length;i++){
		print( [user_json.key.valueOf()].concat( stage_result[i] ) )
	}
}



// cursor = db.getCollection('activities').find(
// 	// { $where : "this.stages.length>=10 " },
// 	{'stages.stage'}
// 	// {	
// 	// 	$or:[	{ key : "PZIw4nSY" },	{ key : "injjJ2rM" }]
// 	// },
// 	{
// 		key:1, "stages.stageId":1, "stages.actions.name":1,
// 		"stages.actions.data.key":1, "stages.actions.data.value":1,
// 		"stages.actions.timestamp" : 1,
// 		_id:0
//     }
// )



cursor = db.getCollection('activities').find(
	// { "stages.stageId": { $in: [ /^4-10/i ] } }
	{ "stages.stageId": { $in: [ /^4-/i ] } }
	,{
		key:1, "stages.stageId":1, 
		"stages.actions.name":1,
		"stages.actions.data.key":1, "stages.actions.data.value":1,
		"stages.actions.timestamp" : 1,
		_id:0
    }
)

while (cursor.hasNext()) {
  	parsing_user_json(cursor.next())
}
