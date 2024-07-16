#### A Flutter package that simplifies scrolling to a specific index within a list of widgets that have different heights


## Usage
The package provides 3 widgets with different customizations for each 

#### LabeledTabViewSync
use this widget to provide a label tab bar
![](assets/videos/labeled.gif)
```dart
LabeledTabViewSync<DepartmentModel>(
        items: departments,
        itemBuilder: (department, isSelected) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(department.name,
                style: TextStyle(
                  fontSize: 20,
                  color: isSelected ? Colors.white : Colors.black38,
                )),
            const SizedBox(
              height: 8,
            ),
            ...department.employees.map((employee) => ListTile(
                  title: Text(
                    employee,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black38,
                    ),
                  ),
                ))
          ],
        ),
        tabBuilder: (DepartmentModel item, bool isSelected) => SizedBox(
          height: 24,
          child: Text(
            item.name,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black38,
            ),
          ),
        ),
        labelStyle: LabelStyle(
            color: Colors.deepPurple,
            height: 24,
        ),
        barStyle: const BarStyle(height: 32, padding: EdgeInsets.zero),
      )
```

#### IndicatedTabViewSync
use this widget to provide a  tab bar with indicator
![](assets/videos/indicated.gif)

```dart
 IndicatedTabViewSync<DepartmentModel>(
        items: departments,
        itemBuilder: (department, isSelected) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(department.name,
                style: TextStyle(
                  fontSize: 20,
                  color: isSelected ? Colors.white : Colors.black38,
                )),
            const SizedBox(
              height: 8,
            ),
            ...department.employees.map((employee) => ListTile(
                  title: Text(
                    employee,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black38,
                    ),
                  ),
                ))
          ],
        ),
        tabBuilder: (DepartmentModel item, bool isSelected) => SizedBox(
          height: 24,
          child: Text(
            item.name,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black38,
            ),
          ),
        ),
        indicatorStyle: IndicatorStyle(
            indicatorColor: Colors.deepPurple,
            overlayColor: Colors.deepPurple.shade200,
            indicatorThickness: 2,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
            indicatorSize: TabBarIndicatorSize.label),
        barStyle: const BarStyle(height: 32, padding: EdgeInsets.zero),
      )
```

#### IndexedListSync
Also , you can use ```IndexedListSync``` to scroll to specific index by passing the selected index

![](assets/videos/indexed_list.gif)
```dart
  ValueNotifier<int>selectedIndex=ValueNotifier(0);

 ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
    builder: (_,value,__) => IndexedListSync<DepartmentModel>(
        selectedIndex: value,
        items: departments,
        itemBuilder: (department, isSelected) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Text(department.name,style: TextStyle(
        fontSize: 20,color: isSelected ? Colors.white : Colors.black38,
        )),
        const SizedBox(
        height: 8,
        ),
        ...department.employees.map((employee) => ListTile(
        title: Text(
        employee,
        style: TextStyle(
        color: isSelected ? Colors.white : Colors.black38,
                  ),
            ),
        ))],
            ),);
```



