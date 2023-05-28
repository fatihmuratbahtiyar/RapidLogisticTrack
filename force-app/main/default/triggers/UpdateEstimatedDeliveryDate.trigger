trigger UpdateEstimatedDeliveryDate on Package__c (after insert, after update) {
    List<Id> shipmentIdsToUpdate = new List<Id>();
    for (Package__c packageRecord : Trigger.new) {
        shipmentIdsToUpdate.add(packageRecord.Shipment__c);  
    }
    List<Shipment__c> shipmentsToUpdate = [SELECT Id, Estimated_Delivery_Date__c, (SELECT Id, Weight_KG__c, Dimension__c FROM Packages__r) FROM Shipment__c WHERE Id IN :shipmentIdsToUpdate];
	 for (Shipment__c shipmentRecord : shipmentsToUpdate) {
        List<Package__c> packages = shipmentRecord.Packages__r;
         
             
             if (packages.size() > 0) {
             Date dimensionDeliveryDate = dimensionsEstimatedDate(packages);
             if (dimensionDeliveryDate != null && dimensionDeliveryDate != shipmentRecord.Estimated_Delivery_Date__c) {
                 shipmentRecord.Estimated_Delivery_Date__c = dimensionDeliveryDate;
             
             }
         }
}
    if (shipmentsToUpdate.size() > 0) {
        update shipmentsToUpdate;
    }
    
    //For each "package dimension" more than 3 cubic meters, the "shipment estimated time" is extended by 1 day. for 16 m3 estimated delivery test will be extended 6 days.
    
    private Date dimensionsEstimatedDate(List<Package__c> packages) {
        Integer maxDays = 0;
        for (Package__c packageRecord : packages) {
            Decimal dimension = packageRecord.Dimension__c;
            decimal a = Math.ceil(dimension / 3);
            Integer daysToAdd = a.intValue();
            if (daysToAdd > maxDays) {
    			maxDays = daysToAdd ;
            }
        }
        Date dimensionsEstimatedDate = System.today().addDays(maxDays);
        return dimensionsEstimatedDate;
    }   
    
}