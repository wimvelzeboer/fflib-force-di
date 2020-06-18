# fflib-force-di

## Di Configurator

The Di Configurator makes it easier to create bindings on the fly during run time.

### Method reference

 - [createApexBinding](#createapexbinding)

#### createApexBinding
```apex
static void createApexBinding(Type binding, Type implementation);
static void createApexBinding(String bindingName, Type implementation);
static void createApexBinding(Map<String, Type> implementationByBindingName);
```
Registers a new module in the Di Injector for the given binding and implementation

###### Example
In this example we have the following two classes
**MyClass.cls**
```apex
public interface MyClass { ... }
```
**MyClassImp.cls**
```apex
public class MyClassImp implements MyClass { ... }
```

To create the binding for this interface to its implementation use
```apex
di_Configurator.createApexBinding(MyClass.class, MyClassImp.class);
```
A new instance of the binded implementation can be retrieved via
```apex
MyClass myClass = (MyClass) di_Injector.Org.getInstance(MyClass.class);

System.assert(myclass instanceof MyClassImp); // should evaluate to true
```
