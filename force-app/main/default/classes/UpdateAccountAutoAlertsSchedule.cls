/**
*
* @Name                      : UpdateAccountAutoAlertsSchedule
* @Author                    : Deepak - Happiest Minds
* @Description               : scheduling UpdateAccountAutoAlertsSchedule (will start at 01:30 am)
* @Created date              : 29-08-2018
*
**/

global class UpdateAccountAutoAlertsSchedule implements Schedulable 
{
    public static String CRON_EXP =  '0 30 1 ? * *';

    global void execute(SchedulableContext sc) 
    {
    
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        
        system.debug('cronexpr:' + ct.CronExpression);
        System.debug('trigertimes:' + ct.TimesTriggered);
        System.debug('nextfiretime:' + String.valueOf(ct.NextFireTime));
        
        
        //scheduling Auto alert update batch job
        UpdateAccountAutoAlerts autoAlert= new UpdateAccountAutoAlerts();
        string autoAlertId = database.executebatch(autoAlert,10);
        System.debug('======= Auto Alert Id ======' + autoAlertId); 
    }
}