db.getCollection('activities').find(
	{ $where : "this.stages.length>40" },
	{
		_id:0, "stages._id":0, "stages.actions._id":0, "stages.actions.data._id":0
		updated:0, created:0, "stages.startTime":0, 
        "stages.actions.timestamp":0, "stages.startTime":0, "stages.finishTime":0
    }
)



db.getCollection('activities').find(
	{ $where : "this.stages.length==40" },
	{
		key:1, "stages.stageId":1, "stages.actions.name":1, _id:0
    }
)




///get (user, stages[])


db.activities.aggregate(
   [
   		
    	{$project: {
    		_id:0,
			key: 1,
			"stages.stageId":1, "stages.actions.name":1,
			stage_cnt: { $size: "$stages" }
			}
    	},
    	{ $match :  { "stage_cnt" : {$eq : 10} } }
   ]
)

db.activities.find({key:qf60A3ud})



//////////////////

var data = db.activities.aggregate(
   [
   		
    	{$project: {
    		_id:0,
			key: 1,
			"stages.stageId":1, "stages.actions.name":1,
			stage_cnt: { $size: "$stages" }
			}
    	},
    	{ $match :  { "stage_cnt" : {$eq : 40} } }
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



