/**
 * File Name: di_ConfiguratorTest 
 * Description: Unit test class for the di_Configurator
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest
private with sharing class di_ConfiguratorTest
{
	@IsTest
	static void itShouldAddBindingDynamically()
	{
		// GIVEN a current set without the binding we want to add
		String newBindingName = 'TEST.newBuildingName';
		List<di_Binding> bindingsByName = di_Injector.Org.Bindings.byName(newBindingName).get();
		System.assert(bindingsByName.isEmpty(), 'Initial test data should not contain a binding for '+newBindingName);

		// WHEN we add the binding
		System.Test.startTest();
		di_Configurator.createApexBinding(newBindingName, testImplementation.class);
		System.Test.stopTest();

		// THEN the binding should be available
		List<di_Binding> result = di_Injector.Org.Bindings.byName(newBindingName).get();
		System.assertEquals(1, result.size(), 'Dynamic binding not found');
		System.assert(
				di_Injector.Org.getInstance(newBindingName) instanceof testImplementation,
				'Incorrect binding returned'
		);
	}

	// Empty class used in test for binding
	public class testImplementation {}
}