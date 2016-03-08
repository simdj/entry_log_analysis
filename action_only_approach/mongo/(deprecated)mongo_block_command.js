

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
action_list_to_parse=['addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone']
extracting_action_and_block = function(action_data){
	var ret='';
	
	var action_name = action_data.name.valueOf();
	var block_type=''

	if(action_list_to_parse.indexOf(action_name) > -1){
		var action_metadata=action_data.data;
		var block_id= ''
		var code=''
		// print(action_name)
		for( index in action_metadata){
			var meta = action_metadata[index]
			
			if(meta.key =="blockId"){
				block_id=meta.value;
			}else if(meta.key=="code"){
				code = meta.value;
			}

		}

		if(block_id && code){
			block_type=traverse(JSON.parse(code),block_id)
		}
		return action_name+"-"+block_type;
	}else{
		return action_name
	}
}


parsing_stages_json = function(stage){ 
	//var ret=[stage.stageId]; 
	//ret.stage=stage.stageId; 
	// return [stage.stageId.valueOf()].concat( stage.actions.map(function(act){return act.name.valueOf()}) );
	
	return [stage.stageId.valueOf()].concat( stage.actions.map(extracting_action_and_block) );
	
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


