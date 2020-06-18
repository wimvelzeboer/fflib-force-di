/**
 * File Name: di_BindingsTest 
 * Description: Unit test class for the domain di_Bindings
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest
private class di_BindingsTest
{
	@IsTest
	static void itShouldCreateInstancesForTheBindings()
	{
		// GIVEN a domain with bindings
		di_Bindings domain = new di_Bindings(
				new List<di_Binding>
				{
						di_Binding.newInstance(
								di_Binding.BindingType.Apex,
								'Test',
								null,
								0,
								new TestClass(),
								null)
				}
		);

		// WHEN we create new instances for all bindings in the domain
		System.Test.startTest();
		Objects objects = domain.newInstances();
		System.Test.stopTest();

		// THEN all instances should be created
		System.assertEquals(1, objects.get().size(), 'Incorrect amount of objects returned');
		System.assert(objects.get().get(0) instanceof TestClass, 'Incorrect implementation returned');
	}

	private class TestClass {}
}