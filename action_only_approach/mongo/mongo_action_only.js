// usage
// mongo entry_3 mongo_action_only.js > [mongo_result_#.csv]

parsing_stages_json = function(stage){ 
	return [stage.stageId.valueOf()].concat( stage.actions.map(function(act){return act.name.valueOf()}) );
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
		$or: [ { key : "PZIw4nSY" },{ key : "injjJ2rM" } ]
		
	},
	{
		key:1, "stages.stageId":1, "stages.actions.name":1, _id:0
    }
)
while (cursor.hasNext()) {
  	parsing_user_json(cursor.next())
}

