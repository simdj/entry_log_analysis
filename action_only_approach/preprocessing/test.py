
class Greg_cal():
    def __init__(self):
        self.dtime = datetime.today()
    
    def __str__(self): 
        return "%04d-%s-%02d %s" %(self.dtime.year, month_name[self.dtime.month%12], self.dtime.day, weekday_list[self.dtime.weekday()])        
    
    def prevdate(self, change):
        self.dtime = self.dtime - timedelta(days = change)      
        return self
    
    def nextdate(self, change):
        self.dtime = self.dtime + timedelta(days = change)   
        return self

#Main#
date = Greg_cal()
