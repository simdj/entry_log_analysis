# entry_log_analysis
Entry log analysis


raw log example
{
    "gender" : 1,
    "year" : 2002,
    "key" : "qf60A3ud",
    "swLearned" : 1,
    "target" : "codingparty",
    "updated" : ("2015-11-30T22:54:48.271Z"),
    "created" : ("2015-11-30T22:54:48.271Z"),
    "stages" : [ 
        {
            "stageId" : "2-1",
            "actions" : [ 
                {
                    "name" : "run",
                    "timestamp" : ("2015-11-30T22:55:57.722Z"),
                    "data" : [ 
                        {
                            "key" : "code",
                            "value" : "[[{\"id\":\"8k9h\",\"name\":null,\"x\":100,\"y\":30,\"type\":\"jr_start\",\"values\":{},\"movable\":false,\"deletable\":false},{\"id\":\"lwsc\",\"name\":null,\"x\":0,\"y\":49.3,\"type\":\"jr_east\",\"values\":{},\"movable\":true,\"deletable\":true}]]",
                        }
                    ]
                }, 
                {
                    "name" : "insertBlock",
                    "timestamp" : ("2015-11-30T22:56:01.794Z"),
                    "data" : [ 
                        {
                            "key" : "targetBlockId",
                            "value" : "lwsc",
                        }, 
                        {
                            "key" : "blockId",
                            "value" : "cvea",
                        }, 
                        {
                            "key" : "code",
                            "value" : "[[{\"id\":\"8k9h\",\"name\":null,\"x\":100,\"y\":30,\"type\":\"jr_start\",\"values\":{},\"movable\":false,\"deletable\":false},{\"id\":\"lwsc\",\"name\":null,\"x\":0,\"y\":49.3,\"type\":\"jr_east\",\"values\":{},\"movable\":true,\"deletable\":true},{\"id\":\"cvea\",\"name\":null,\"x\":0,\"y\":101,\"type\":\"jr_east\",\"values\":{},\"movable\":true,\"deletable\":true}],[]]",
                        },
						{
                            "key" : "positionX",
                            "value" : "100",
                        }, 
                        {
                            "key" : "positionY",
                            "value" : "10",
                        }
                    ]
                },
				
                {
                    "name" : "insertBlock",
                    "timestamp" : ("2015-11-30T22:56:03.215Z"),
                    "data" : [ 
                        {
                            "key" : "targetBlockId",
                            "value" : "cvea",
                        }, 
                        {
                            "key" : "blockId",
                            "value" : "wb7c",
                        }, 
                        {
                            "key" : "positionX",
                            "value" : "100",
                        }, 
                        {
                            "key" : "positionY",
                            "value" : "10",
                        }, 
                        {
                            "key" : "code",
                            "value" : "[[{\"id\":\"8k9h\",\"name\":null,\"x\":100,\"y\":30,\"type\":\"jr_start\",\"values\":{},\"movable\":false,\"deletable\":false},{\"id\":\"lwsc\",\"name\":null,\"x\":0,\"y\":49.3,\"type\":\"jr_east\",\"values\":{},\"movable\":true,\"deletable\":true},{\"id\":\"cvea\",\"name\":null,\"x\":0,\"y\":101,\"type\":\"jr_east\",\"values\":{},\"movable\":true,\"deletable\":true},{\"id\":\"wb7c\",\"name\":null,\"x\":0,\"y\":101,\"type\":\"jr_east\",\"values\":{},\"movable\":true,\"deletable\":true}],[],[]]",
                        }
                    ]
                }
			]
		}
	]
}