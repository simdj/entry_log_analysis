

// printjson(db.getCollection('activities').find(
// 	{	
// 		$or:
// 			[
// 				{ key : "PZIw4nSY" },
// 				{ key : "injjJ2rM" }
// 			]
		
// 	},
	
// 	{
// 		key:1, "stages.stageId":1, "stages.actions.name":1,
// 		"stages.actions.data.key":1, "stages.actions.data.value":1,
// 		_id:0
//     }
// ).toArray())



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


// header_row=['id','lecture','run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone']
action_list_to_parse=['addBlock','insertBlock','moveBlock','seperateBlock']
action_list_to_parse_with_previous=['destroyBlock','destroyBlockAlone']

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

parsing_stages_json = function(stage){ 
	//var ret=[stage.stageId]; 
	//ret.stage=stage.stageId; 
	// return [stage.stageId.valueOf()].concat( stage.actions.map(function(act){return act.name.valueOf()}) );
	action_log_list=[]
	previous_code=''
	for(var index=0;index<stage.actions.length;index++){


		var action = stage.actions[index]; // list of action's metadata
		var action_name = action.name.valueOf(); 

		var block_id= get_metadata_from_action(action,"blockId");
		var code='';
		var block_type='';
		
		var action_log=action_name; // item to append to action_log_list
		
		if(action_list_to_parse.indexOf(action_name)>-1){
			// ['addBlock','insertBlock','moveBlock','seperateBlock']
			code=get_metadata_from_action(action,"code")
			if(block_id && code){
				block_type=traverse(JSON.parse(code),block_id)
			}
			action_log+="-"+block_type;

		}else if(action_list_to_parse_with_previous.indexOf(action_name)>-1){
			// ['destroyBlock','destroyBlockAlone']
			code=get_metadata_from_action(stage.actions[index-1],"code")
			if(block_id && code){
				block_type=traverse(JSON.parse(code),block_id)
			}
			action_log+="-"+block_type;
		}
		action_log_list.push(action_log)
	}
	// return [stage.stageId.valueOf()].concat( stage.actions.map(extracting_action_and_block) );
	// [2-1,insertBlock-jr_east,run,addBlock-jr_east,insertBlock-jr_east,addBlock-jr_east,insertBlock-jr_east,run]
	return [stage.stageId.valueOf()].concat( action_log_list );
}


parsing_user_json = function(user_json){
	stage_result = user_json.stages.map(parsing_stages_json)
	for(var i=0;i<stage_result.length;i++){
		print( [user_json.key.valueOf()].concat( stage_result[i] ) )
	}
}



cursor = db.getCollection('activities').find(
	// { $where : "this.stages.length>=10 && this.stages.length<50 " },
	{	
		$or:
			[
				{ key : "PZIw4nSY" },
				{ key : "injjJ2rM" }
			]
		
	},
	
	{
		key:1, "stages.stageId":1, "stages.actions.name":1,
		"stages.actions.data.key":1, "stages.actions.data.value":1,
		_id:0
    }
)

while (cursor.hasNext()) {
  	parsing_user_json(cursor.next())
}


