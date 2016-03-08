
var data = db.activities.aggregate(
   [
   		
    	{$project: {
    		_id:0,
			key: 1,
			"stages.stageId":1, "stages.actions.name":1,
			stage_cnt: { $size: "$stages" }
			}
    	},
    	{ $match :  { "stage_cnt" : {$gt : 50} } }
   ]
).result




stage_func = function(stage){ 
	//var ret=[stage.stageId]; 
	//ret.stage=stage.stageId; 
	return [stage.stageId].concat( stage.actions.map(function(act){return act.name}) );
	
}


user_unit_func = function(user_unit){
	
	var ret=[]
	stage_result = user_unit.stages.map(stage_func)
	for(var i=0;i<stage_result.length;i++){
		
		ret.push( [user_unit.key].concat( stage_result[i] ) )
	}
	return ret
	
}


data.map(user_unit_func)

