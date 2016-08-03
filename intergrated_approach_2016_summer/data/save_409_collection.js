// save 409 collection
// db.getCollection('raw_activities').find(
// 	{ 
// 		"stageId": "4-9"
// 	},
// 	{}
// ).forEach(function(doc){
// 	db.lecture409.insert(doc);
// })


// duplicate test 
// db.getCollection('lecture409').find({"actions.name":"success"},{_id:1, key:1}).count()
db.getCollection('lecture409').find({"actions.name":"success"},{key:1}).count()
// output: 17062
db.getCollection('lecture409').distinct("key",{"actions.name":"success"})
// output: 16480 


// find duplicated user
var unique_success_user = db.getCollection('lecture409').distinct("key",{"actions.name":"success"})
print(unique_success_user[0])

var success_user = db.getCollection('lecture409').find({"actions.name":"success"},{key:1}).map(function(obj){return obj.key})




// var arr = [2, 2, 2, 2, 2, 4, 5, 5, 5, 9];

function foo(arr) {
    var a = [], b = [], prev;
    
    arr.sort();
    for ( var i = 0; i < arr.length; i++ ) {
        if ( arr[i] !== prev ) {
            a.push(arr[i]);
            b.push(1);
        } else {
            b[b.length-1]++;
        }
        prev = arr[i];
    }
    
    return [a, b];
}

var result = foo(success_user);
print(result)

db.getCollection('lecture409').find({"key":"02D0F9xR"},{}).sort({created:-1})






// // Desired unique index: 
// // db.collection.ensureIndex({ firstField: 1, secondField: 1 }, { unique: true})

// db.getCollection('lecture409').aggregate([
//   { $group: { 
//     _id: { firstField: "$firstField", secondField: "$secondField" }, 
//     uniqueIds: { $addToSet: "$key" },
//     count: { $sum: 1 } 
//   }}, 
//   { $match: { 
//     count: { $gt: 1 } 
//   }}
// ])


