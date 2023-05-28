@isTest
private class UpdateEstimatedDeliveryDateTest {
    @isTest
    static void testEstimatedDeliveryDate() {
        // test data for dimensions records 
        Shipment__c shipment = new Shipment__c(Shipment_Status__c = 'In-Transit', In_transit_Date__c = System.today());
        insert shipment;
        
        Package__c package1 = new Package__c(Shipment__c = shipment.Id, Package_Status__c = 'In-Transit', Weight_KG__c = 100, Package_Heigth__c = 10, Package_Weidth__c = 5, Package_Lenght__c = 8);
        Package__c package2 = new Package__c(Shipment__c = shipment.Id, Package_Status__c = 'In-Transit', Weight_KG__c = 150 , Package_Heigth__c = 8, Package_Weidth__c = 3, Package_Lenght__c = 6);
        Package__c package3 = new Package__c(Shipment__c = shipment.Id, Package_Status__c = 'In-Transit', Weight_KG__c = 200 , Package_Heigth__c = 6, Package_Weidth__c = 4, Package_Lenght__c = 12);
        insert new List<Package__c>{package1, package2, package3};
        
        // Trigger the update
        Test.startTest();
        update shipment;
        Test.stopTest();
        
        // Retrieve the updated shipment record
        shipment = [SELECT Id, Estimated_Delivery_Date__c FROM Shipment__c WHERE Id = :shipment.Id];
        
        // Verify the expected estimated delivery date
        Date esDate = System.today().addDays(134); // Assuming the logic in the trigger sets the estimated delivery date to 134 days to the future
        System.assertEquals(esDate, shipment.Estimated_Delivery_Date__c);
    }
}