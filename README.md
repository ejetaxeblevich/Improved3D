# ПРОСТРАНСТВЕННЫЙ LUA-МОДУЛЬ

Написанный специально для игры Ex Machina / Hard Truck Apocalypse

### Note: Please translate this text, if it nessesary.

[comment]: <> ( Этот readme не имеет красивого оформления, поэтому используйте поиск по тексту вверху справа.)
[comment]: <> ( <div align="center">)
[comment]: <> ( <img width="114" height="92" alt="image" src="https://github.com/user-attachments/assets/9ed52681-407d-44c1-8a02-6df8c0cbd563" />)
[comment]: <> ( </div>)


## ЧТО ЭТО

Универсальный lua-модуль, который может использоваться для **расширения возможностей** на "манипулирование пространством" в игре.

Вы сможете более **гибко расчитывать координаты и вращение, удобно РАЗМЕЩАТЬ и ВРАЩАТЬ объекты**, пользоваться некоторыми техническими возможностями **через скрипты** любой модификации внутри игры.

> ![ModuleDemoGif](exm_improved3d_demo.gif)
> exm_improved3d_demo.gif

### ВОЗМОЖНОСТИ
- **Полный контроль вращения `Quaternion`** - теперь не нужно гадать, что это за цифры! Вам достаточно представить градусы по трем осям `x` `y` `z`!
- **Полный контроль координат `CVector`** - легко двигать и размещать объекты относительно друг друга!
- **Взаимодействие с игровой камерой** - можно узнать, куда она смотрит и что находится в ее поле зрения!
- **Размещение объектов по окружности** с любым желаемым вращением - отличное решение для машин мелких банд и `FlyAround`!
- **Поворот объекта в любую сторону** - теперь *может аимиться не только камера* в катсценах!
- Запись координат и вращения для машин игровой камерой - в оригинале у камеры *сломанное* вращение, получалось только другой машиной/объектом!
- Сбор машин по имени их `team`, объектов по именам/айди в один удобный список!
- Набор команд для удобного просчета координат, вращения, векторов в пространстве для своих скриптов - экономия времени!
- Другие небольшие и полезные скрипты!

<!--
И это только благодаря сухой и неинтересной математике за 6 класс учебника Виленкин Н. Я.🤣
-->

### Дисклеймер

АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК.


АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ НАПИСАННОМ ДИСКЛЕЙМЕРЕ.


LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.

АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.

<!--
## [СКАЧАТЬ Improved3D](https://github.com/ejetaxeblevich/Improved3D/blob/main/improved3d.lua)
Перейдя на страницу, нажмите на кнопку **"Download raw file"**.
-->

## КАК ЭТО ИСПОЛЬЗОВАТЬ

Почему это "модуль", а не любой другой файл с lua-скриптами? Хотя он таким и является...
- Потому что этот файл - таблица функций I3D (далее класс), который имеет свои собственные методы и функции, что очень похоже на серьезную тему. Наверное. Типа. Я хз...

### УСТАНОВКА

Для полноценного lua-модуля этой поделке еще далеко, поэтому ее не нужно устанавливать как библиотеку Lua в системе.

В игру этот lua-модуль загружается двумя способами: через `require()` или `dofile()`. Это внутренние Lua команды игры. 
Наш знакомый `EXECUTE_SCRIPT` не подойдет, так как он не возвращает объект модуля.


Чем отличается `require()` от `dofile()`? 


- `require()` загружает файл в игру при первом выполнении и держит в памяти игры до перезапуска. Эта команда используется для подгрузки модулей здорового человека, которые устанавливаются в систему (но необязательно);
- `dofile()` загружает в память игры файл столько раз, сколько был вызван. Очищается весь внутренний кеш lua-модуля и принимаются настройки по умолчанию. Рекомендуется для отладки и прочего дебага.

Рекомендую прописывать команду в конец файла `server.lua` игры, поскольку могут использоваться в модуле команды, которые грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).


В качестве аргумента функции указывается локальный путь до файла модуля.


Возвращаемая таблица помещается в глобальную переменную, которая будет использована как объект, на который будут применяться методы (функции) этого модуля через двоеточие. 

Чтобы было понятнее, вспомним как мы обращаемся к машине игрока: 
```lua
local Plv = GetPlayerVehicle()
if Plv then
    Plv:SetSkin(1)  --> метод на объект
end
```
Или к обжект контейнеру:
```lua
local Gde = CVector(1,2,3)
local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> метод на объект
```

После загрузки модуля в игру уже можно начинать пользоваться его командами.

### Пример кода загрузки

```lua
--server.lua
I3D = require("data\\gamedata\\lua_lib\\improved3d.lua")
if not I3D then
    LOG("[E] Could not find global Improved3D.lua...")
end
```

### Пример использования
```lua
--triggers.xml
local Plv = GetPlayerVehicle()
if Plv then
    local PlvInCamera = I3D:IsInCameraView(Plv:GetPosition())
    if PlvInCamera then
        println("player vehicle in camera!")
    end
end
```

## ТЕХНИКА БЕЗОПАСНОСТИ

- ***РЕКОМЕНДУЕТСЯ*** перед работой ознакомиться с памятками ниже ***[Что такое "координаты"]***, ***[Что такое "вращение"]*** и ***[Что такое "направление"]*** в понимании игры и этого lua-модуля. *В противном случае гарантия правильной работы аннулируется.*

- ***ЗАПРЕЩАЕТСЯ*** использовать этот lua-модуль в своих модах без указания авторства. А то натравлю порчу и наколдую недельный понос 😡 
*Шутка 💋*

## ФУНКЦИИ И МЕТОДЫ

Здесь собраны все публичнные функции этого модуля. У каждой функции имеется детальное описание, что она делает и что в ней указывать. 

Стандартное вращение является `Quaternion(0,0,0,1)` или *`Euler(0,0,0)` - **объект смотрит ВПЕРЕД по оси Z на север карты**, от этого направления строится любое вращение. Это следует помнить во время написания скриптов. (\**Euler(0,0,0)* - не является функцией, просто наглядное сравнение.)

Для настройки работы `IsCameraLookAt` можно и нужно редактировать функцию `IsCameraLookAt_Callback` раздела `USER EDITABLE FUNCTIONS` внутри файла. Стоит также ознакомиться с триггером `IsCameraLookAt_VectorDrawer`.

```c
Class I3D
{
    /* Расширенное манипулирование 3D пространством */
    [M] table Positions SetObjectsAroundCircle( table ListOfObjects, CVector CenterPos, Quaternion BaseRotation, float Radius, float StartAngleDeg, bool or Quaternion LookOutside, bool AutoRadius, bool PosAbsolute )    /* Размещает выбранные объекты ListOfObjects по окружности в позиции CenterPos и вращением орбиты BaseRotation с начальным радиусом Radius, с углом смещения первого объекта по орбите на StartAngleDeg. Объекты смотрят наружу, если LookOutside = true, иначе внутрь, можно передать Quaternion для своего вращения. Объекты размещаются с динамическим радиусом, зависящим от длины конкретного объекта, если AutoRadius = true, иначе выравнивание по длине первого объекта в списке (чтобы не спавнились друг в друге). Размещает объекты с фиксированной высотой, если PosAbsolute = true, иначе на ландшафте */
    [M] Quaternion SetObjectLookAt( object SetAim, object GetAim, bool OnlyYaw, bool LockRoll )    /* Обращает взор первого объекта на позицию второго объекта - как аим камеры в катсценах. Для плавной работы необходимо вызывать каждый раз: objSetAim = объект, который нужно повернуть; objGetAim = объект или позиция, на которую надо "смотреть": может быть getObj(), CVector(), GetCameraPos(); boolOnlyYaw = применяется вращение только по оси Y (как турель), если true; boolLockRoll = запрещается вращение по оси Z (наклон), если true. Примеры: SetObjectLookAt(getObj("aim_object_name"), GetPlayerVehicle(), false, true) --> Аим на объект; SetObjectLookAt(getObj("aim_object_name"), GetCameraPos(), false, true) --> Аим на камеру */
    [M] void IsCameraLookAt( float DrawVectorQuant, float DrawVectorQuantMultiplier, float DrawVectorMinDistance, float DrawVectorMaxDistance, float DrawCatchZoneSize )        /* Смотрит ли куда-то камера? Бросает луч из камеры и пытается что-то "нащупать" (работает с триггером "IsCameraLookAt_VectorDrawer" или с IsCameraLookAt_VectorDrawer_f()): float DrawVectorQuant = шаг построения отрезка луча (в метрах); float DrawVectorQuantMultiplier = множитель шага построения отрезка луча (1.0); float DrawVectorMinDistance = минимальное расстояние, после которого идет захват объекта лучом (в метрах); float DrawVectorMaxDistance = максимальное расстояние захвата объектов лучом (в метрах); float DrawCatchZoneSize = размер зоны захвата объектов в точке луча (в метрах); Оригинальный lookAt у [GetCameraPos()] сломан. Пример использования: I3D:IsCameraLookAt(5,1,20,1000,5) */
    [M] ??? IsCameraLookAt_Callback( CVector pos, Object entity )     /* Настраивается пользователем. Эта callback-функция вызывается GetCameraLookAtProcess, когда он завершается. Нужна как обработка ивента окончания работы луча. Аргументы возвращает сам GetCameraLookAtProcess: pos = CVector точки, куда смотрела камера на момент вызова IsCameraLookAt(); entity = Object сущности, какую захватил луч, может быть nil. Доступен такой же контроль, как через GetEntityByName() */
    [M] bool IsInCameraView( CVector pos, table region )              /* Находится ли точка в поле зрения камеры. Границы захвата на экране region={} пропорционально с left, right, bottom, top (от -1 до 1) */
    [M] bool IsInCameraViewSquared( CVector pos, float ScopeCoeff )   /* Находится ли точка в поле зрения камеры. Границы захвата на экране в квадратном соотношении с ScopeCoeff (от -1 до 1) */
    [M] bool IsObjectInCameraView( object Entity, float ScopeCoeff, bool SquareScope )   /* Находится ли объект в поле зрения камеры. Объединяет между собой [IsInCameraViewSquared] и [IsInCameraView], где: Entity - объект как getObj() или GetEntityByName(); ScopeCoeff - коэффициент размера зоны захвата на экране (от 0 до 1, где 1 = весь экран). Может быть как region={} с left, right, top, bottom (от -1 до 1); SquareScope - квадратное соотношение зоны захвата, если true */
    [M] CVector RotateAroundPoint( CVector 1, CVector 2, Quaternion or tableRotation )   /* Возвращает точку повернутого вектора2 вокруг вектора1 на угол tableRotation [{90,0,0}] или Quaternion() */
    [M] CVector LinearMoveAroundPoint( CVector 1_old, CVector 1_new, CVector 2_old )     /* Возвращает точку сдвинутого вектора2 линейно вместе с вектором1: 1_old = последняя сохраненная позиция вектора1; 1_new	= новая позиция вектора1; 2_old	= последняя сохраненная позиция вектора2 */
    [M] CVector AdjustDistanceBetweenVectors( CVector 1_old, CVector 2_old, float target_dist )     /* Возвращает точку вектора2 на нужном расстоянии от вектора1: 1_old = последняя сохраненная позиция вектора1; 2_old = последняя сохраненная позиция вектора2; target_dist = требуемое расстояние между векторами */
    [M] CVector GetEndOfBeam( CVector origin, Quaternion, float distance )      /* Возвращает точку на расстоянии distance от origin, направленную по вращению quaternion */
    [M] CVector&boolObstacle DrawVector( CVector origin, Quaternion, float distance )    /* Рисует вектор в игровом мире длиной distance от origin, направленного по вращению quaternion и возвращает его вторую точку (воспринимает препятствия в виде ландшафта и края карты) */
    [M] Quaternion QuaternionFromTo( CVector From, CVector To )           /* Возвращает кватернион от вектора к вектору (вращение из одного направления в другое) */
    [M] Quaternion QuaternionByLandscape( CVector vec, Quaternion rot )   /* Возвращает кватернион по уровню ландшафта. Выравнивает объект по ландшафту, чтобы он не был строго в горизонте при появлении */
    [M] CVector RotateCVectorByQuaternion( CVector, Quaternion )    /* Возвращает точку помноженного вектора на кватернион (поворот CVector по вращению Quaternion) */
    [M] CVectorX&CVectorY&CVectorZ QuaternionToAxes( Quaternion )   /* Возвращает направления по осям из кватерниона */
    [M] Quaternion QuaternionFromAxes( CVector right, CVector up, CVector forward )  /* Возвращает кватернион из направлений по осям */
    [M] CVector GetForwardFromQuaternion( Quaternion )      /* Возвращает направление "вперед" из вращения */
    [M] CVector CVectorAverage( table Positions, bool Y )   /* Возвращает точку как среднее арифметическое векторов, считает Y если true */
    [M] Object CallEntityInZone( CVector pos, float ZoneSize, bool GetsIntoCamera )     /* Возвращает объект, что находится в желаемой точке: posVector = CVector точки, позиция камеры если nil; float ZoneSize = размер зоны у точки, в которой может быть объект (в метрах); bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true */
    [M] table GetAllEntities( bool GetsIntoCamera )         /* Возвращает все объекты на карте, что имеют позиции CVector и их количество: bool GetsIntoCamera = захватывает только объекты в поле зрения камеры, если true */

    /* Помощь в расчетах */
    [M] bool IsCVector( userdata )      /* Проверяет значение юзердаты, что это координаты CVector */
    [M] bool IsQuaternion( userdata )   /* Проверяет значение юзердаты, что это вращение Quaternion */
    [M] string IsUserdata( userdata )   /* Проверяет значение юзердаты. Объединяет [IsCVector()] и [IsQuaternion()], возвращая строковые значения для сравнения: ["cvector"], ["quaternion"], ["userdata"], ["not userdata"]. Бонусом может вернуть строкой класс объекта */
    [M] table UpdateScreenInfo()        /* Обновляет переменные модуля и возвращает fov, width и height окна игры */
    [M] table CollectExternalPaths( string PathNamePrefix, string CollectPostfix )  /* Возвращает и принтит в лог список External Paths с пронумерованными именами текущей карты. Префикс имени PathNamePrefix может быть любым; постфикс имени CollectPostfix должен содержать число с которого начнется отсчет. Пример: "pathName" и "_0" для имен: "pathName_0", "pathName_1" */
    [M] table CollectCameraPaths( string PathNamePrefix, string CollectPostfix )    /* Возвращает и принтит в лог список Camera Paths с пронумерованными именами текущей карты. Префикс имени PathNamePrefix может быть любым; постфикс имени CollectPostfix должен содержать число с которого начнется отсчет. Пример: "pathName" и "_0" для имен: "pathName_0", "pathName_1" */
    [M] int MoveObject( object Entity, string PathName, float MoveTime, string MoverName )   /* Обертка cinematicMover с именем MoverName, возвращает его ID. Объект Entity начинает полет по пути камеры PathName и укладывается во время MoveTime (секунды) */
    [M] void MoveObjectsByPaths( table Objects, table PathNames, float MoveTime, string MoverName )   /* Выбранные объекты начинают движение по каждому своему пути, обертка [MoveObject()] под несколько объектов. Количество элементов в списках должно быть одинаковым */
    [M] CVector GetCameraPos()      /* Обертка стандартного [GetCameraPos()] под координаты */
    [M] Quaternion GetCameraRot()   /* Возвращает исправленное вращение камеры от [GetCameraPos()]. Оригинальное вращение зеркально от полюсов, которое нормально работает для камеры в катсценах, но не для объектов */
    [M] CVector ParseCVector( string CVector )     /* Возвращает CVector из строки с CVector (юзердату) */
    [M] Quaternion ParseQuaternion( string Quaternion )      /* Возвращает Quaternion из строки с Quaternion (юзердату) */
    [M] table Positions ItemsToCVectors( table Items )       /* Преобразует список из разных элементов в список с их CVector (юзердаты). Элементами могут быть: ["MyVehicleName"], [getObj()], ["1 2 3"], [CVector(1,2,3)] */
    [M] table Objects CollectVehiclesByTeam( string TeamName )   /* Возвращает список найденных машин из команды по имени TeamName */
    [M] table Objects CollectObjects( table ObjectNamesOrIDs )   /* Возвращает список найденных объектов из списка. Могут быть имена и айди */
    [M] Quaternion EulerToQuaternion( float x, float y, float z, bool LOG )   /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. */
    [M] floatX&floatY&floatZ QuaternionToEuler( Quaternion, bool LOG )        /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. */
    [M] Quaternion GetFixedQuaternion( Quaternion )     /* Возвращает исправленное вращение. Как понять, что ваше вращение понос спидозного бомжа? - объект хуй пойми куда смотрит, а не куда ему нужно */
    [M] float CVectorDot( CVector 1, CVector 2 )        /* Возвращает скалярное произведение двух векторов */
    [M] CVector CVectorCross( CVector 1, CVector 2 )    /* Возвращает точку векторного произведения двух векторов */
    [M] CVector CVectorNormalize( CVector )       /* Возвращает нормализацию вектора */
    [M] int GetMapSize()     /* Возвращает константу размера текущей карты в метрах */

    /* Сервисные функции. По возможности не используйте */
    [M] CVector&Object IsCameraLookAt_VectorDrawer_f()      /* Функция вместо триггера "IsCameraLookAt_VectorDrawer". Плюсы: Луч строится мгновенно; Минусы: Экс Машина */
    [M] Quaternion CVectorEulerToQuaternion( float pitch, float yaw, float roll, bool LOG )     /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. Используйте на входе: pitch = y, yaw = z, roll = x */
    [M] floatX&floatY&floatZ CVectorQuaternionToEuler( Quaternion, bool LOG )   /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. Используйте на выходе pitch = y, yaw = z, roll = x. */
}
```
## Что такое "координаты"
В игре координатами являются три числовых значения, которые **задают точку в пространстве** на игровом уровне и измеряются в метрах: `x` `y` `z`, где `x` - запад/восток; `y` - вверх/вниз; `z` - север/юг. Координаты отсчитываются от левого нижнего края игрового уровня (юго-запад) и зависят от его размера.

- Вид координат: `CVector(1,2,3)` - `1`=`x`, `2`=`y` и `3`=`z`.

## Что такое "вращение"
В игре вращением является система правонаправленного кватерниона, содержащего четыре числовых значения, который **задает вращение в пространстве**: `x` `y` `z` `w`, где `x` - вращение по оси `x`; `y` - вращение по оси `y`; `z` - вращение по оси `z`; `w` - вращение на угол θ (тэта). Значения могут быть от `-1` до `1`. Кватернион считается по синусам и косинусам половин углов в радианах по формулам. *Improved3D позволяет вам считать углы Эйлера по трем осям в углы кватерниона и наоборот.*

- Вид вращения: `Quaternion(0,0,0,1)` - нули для осей `x` `y` `z` и `1` для поворота θ - север (`0` для поворота θ - юг, инверсия).

## Что такое "направление"
В игре направлением является вектор координат `CVector`, который **задает направление в пространстве**. Значения осей `x` `y` `z` складываются и получается вектор с нужным направлением и длиной (силой). Любой физический объект в игре содержит информацию о своем направлении (движении), даже если он стоит на месте. Расчет направлений необходим для смещения точек и вращений относительно друг друга.

- Вид направления: `CVector(0,0,1)` - вектор направлен на север карты; `CVector(0,1,0)` - вектор направлен вверх; `CVector(1,0,0)` - вектор направлен на восток карты.


## Триггер `IsCameraLookAt_VectorDrawer`

```xml
<trigger Name="IsCameraLookAt_VectorDrawer" active="0">
    <event timeout="0.001" eventid="GE_TIME_PERIOD" />
    <script>
        trigger:IncCount()
        local skoka = trigger:GetCount()
        local pos, obstacle = I3D:DrawVector(I3D.LookAtCVector, I3D.LookAtQuaternion, I3D.LookAtDistance)
        I3D.LookAtDistance = I3D.LookAtDistance * I3D.LookAtDistanceCoeff
        I3D.LookAtCVector = pos
        local entity = nil
        if (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMin) then
            entity = I3D:CallEntityInZone(pos, I3D.LookAtZoneSize)
        end
        if obstacle or entity or (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMax) then
            coroutine.resume(_G["GetCameraLookAtProcess"], pos, entity)
            trigger:Deactivate()
        end
    </script>
</trigger>
```

## ПОДРОБНЕЕ

Эту и другую информацию вы сможете найти в файле проекта или найти примеры работы модуля в моде ExplorerMod от того же автора.

О игровых картах вы можете посмотреть в *[обучающей статье на DeusWiki](https://deuswiki.com/w/Участник:Axeble)* от того же автора.


## КОММЕНТАРИИ АВТОРА

    E Jet: Спасибо нашим поварам за то, что вкусно варят нам!

Благодарность ***crtvxxx*** за помощь с `math.`! 
- В импортированной функции из ExplorerMod на спавн по окружности я впервые столкнулся с проблемой МАТЕМАТИКИ! Пусть функция и была переписана полностью, но уважение вечно! Этот парень выручил целую фичу!
