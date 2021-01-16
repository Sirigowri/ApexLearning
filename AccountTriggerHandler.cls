public class AccountTriggerHandler {
    public static void beforeDeleteValidator(List<Account> oldAccountList){
        System.debug('oldAccountList'+oldAccountList);
        if(oldAccountList.size()>0){
            for(Account acc:oldAccountList){
                if(acc.locked__c==true){
                    System.debug('Inside if');
                    acc.locked__c.adderror('Locked Accounts cannot be deleted');
                }
            }
        }
    }
    public static void beforeUpdateValidator(List<Account> AccountList){
        System.debug('AccountList'+AccountList);
        if(AccountList.size()>0){
            for(Account acc:AccountList){
                if(acc.locked__c==true){
                    acc.locked__c.adderror('Locked Accounts cannot be updated');
                }
            }
        }        
    }  
    public static void invoiceUpdateValidator(List<Account> AccountList){
        System.debug('AccountList'+AccountList);
        List<Invoice__c> invoicelist =new List<Invoice__c>();
        List<Account> accList = new List<Account>();
        if(AccountList.size()>0){
            for(Account acc:AccountList){
                if(acc.generateInvoice__c == 'Generate Invoice'){
                    Invoice__c inv = new Invoice__c();
                    inv.Name = 'New Invoice'+ acc.Name;
                    acc.generateInvoice__c = 'Billing Processed';
                    invoicelist.add(inv);
                    //insert inv; //Wrong way of using DML in for loop
                }
            }
        }
        try{
            insert invoicelist;
        }
        catch(DMLException e){
            System.debug('e'+e);
        }      
    }
}
