trigger Hosp_Contract on Contract__c (before insert, before update) {
    if(Trigger.isInsert || Trigger.isUpdate) {
        Contract__c contractToCheck = Trigger.new[0];

        List<Contract__c> contracts = [SELECT Id, Doctor__c, Hospital__c, StartDate__c, EndDate__c
            FROM Contract__c
            WHERE Doctor__c = :contractToCheck.Doctor__c
                AND Hospital__c = :contractToCheck.Hospital__c];

        for(Contract__c contract : contracts) {
            if((contractToCheck.StartDate__c >= contract.StartDate__c && contractToCheck.StartDate__c <= contract.EndDate__c)
                    || (contractToCheck.EndDate__c>= contract.StartDate__c && contractToCheck.EndDate__c <= contract.EndDate__c)) {
                contractToCheck.addError(Label.Contract_at_the_same_time, false);
            }
        }
    }
}