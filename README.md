#### A Flutter package that simplifies scrolling to a specific index within a list of widgets that have different heights


<br><img src="https://github.com/WissamALSbenaty/Flutter-Tab-Sync/raw/main/assets/videos/flowers.gif"  width="200" height="400"><br>
## Usage
The package provides 3 widgets with different customizations for each 

#### LabeledTabViewSync
use this widget to provide a label tab bar

<br><img src="https://github.com/WissamALSbenaty/Flutter-Tab-Sync/raw/main/assets/videos/labeled.gif"  width="200" height="400"><br>
   

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
<br><img src="https://github.com/WissamALSbenaty/Flutter-Tab-Sync/raw/main/assets/videos/indicated.gif"  width="200" height="400"><br>

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
<br><img src="https://github.com/WissamALSbenaty/Flutter-Tab-Sync/raw/main/assets/videos/indexed_list.gif"  width="200" height="400"><br>
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



