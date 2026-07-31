<a id="top"></a>

<div align="center">

# Improved3D.lua

***ПРОСТРАНСТВЕННЫЙ LUA-МОДУЛЬ,*** *написанный специально для игры [Ex Machina](https://store.steampowered.com/app/285500/Hard_Truck_Apocalypse__Ex_Machina/)*


***SPATIAL LUA-MODULE,*** *written specifically for the game [Hard Truck Apocalypse](https://store.steampowered.com/app/285500/Hard_Truck_Apocalypse__Ex_Machina/)*

**Lua 5.0**

<img src="exm_improved3d_demo.gif" alt="exm_improved3d_demo_gif" />

***

<table>
  <thead>
    <tr>
      <th style="text-align: center;">Содержание</th>
      <th style="text-align: center;">Table of contents (machine translation)</th>
    </tr>
  </thead>
  <tbody align="center">
    <tr>
      <td><a href="#wtf_ru">Краткое описание</a></td>
      <td><a href="#wtf_en">Brief description</a></td>
    </tr>
    <tr>
      <td><a href="#allAboutIt_ru">Все инструкции для моддеров</a></td>
      <td><a href="#allAboutIt_en">All instructions for modders</a></td>
    </tr>
    <tr>
      <td><a href="#allFunctions_ru">Все методы и функции</a></td>
      <td><a href="#allFunctions_en">All methods and functions</a></td>
    </tr>
    <tr>
      <td><a href="#aboutCVectorAndQuaternion_ru">Важное про CVector и Quaternion</a></td>
      <td><a href="#aboutCVectorAndQuaternion_en">Important about CVector and Quaternion</a></td>
    </tr>
    <tr>
      <td><a href="#triggerIsCameraLookAt_ru">Пример триггера для IsCameraLookAt</a></td>
      <td><a href="#triggerIsCameraLookAt_en">Trigger example for IsCameraLookAt</a></td>
    </tr>
    <tr>
      <td><a href="#howToDoFlyingObject_ru">Как сделать летающий объект, как на гифке</a></td>
      <td><a href="#howToDoFlyingObject_en">How to make a flying object like in a gif</a></td>
    </tr>
    <tr>
      <td><a href="#detailsAndThanks_ru">Подробности и выражение благодарности</a></td>
      <td><a href="#detailsAndThanks_en">Details and gratitude</a></td>
    </tr>
  </tbody>
</table>

</div>

> [!WARNING]
> Этот ReadMe актуален только для последней версии Improved3D!
>
> This ReadMe is relevant only for the latest version of Improved3D!

***

<a id="wtf_ru"></a>

## ЧТО ЭТО

Универсальный lua-модуль, который может использоваться для **расширения возможностей** на "манипулирование пространством" в игре.

Вы сможете более **гибко расчитывать координаты и вращение, удобно РАЗМЕЩАТЬ и ВРАЩАТЬ объекты**, пользоваться некоторыми техническими возможностями **через скрипты** любой модификации внутри игры.

> Задача lua-модуля - как-то упростить работу участникам сообщества в создании модификаций, если им сложно реализовать что-то самостоятельно.

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

<a id="allAboutIt_ru"></a><a href="#top">Наверх ↑</a>

### Дисклеймер

АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК.


АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ НАПИСАННОМ ДИСКЛЕЙМЕРЕ.


LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.

АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.

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

<a id="allFunctions_ru"></a><a href="#top">Наверх ↑</a>

## ФУНКЦИИ И МЕТОДЫ

Здесь собраны все публичнные функции этого модуля. У каждой функции имеется детальное описание, что она делает и что в ней указывать. 

> [!IMPORTANT]
> Стандартное вращение является `Quaternion(0,0,0,1)` или *`Euler(0,0,0)` - **объект смотрит ВПЕРЕД по оси Z на север карты**, от этого направления строится любое вращение. Это следует помнить во время написания скриптов. (\**Euler(0,0,0)* - не является функцией, просто наглядное сравнение.)
> 
> Для настройки работы `IsCameraLookAt` можно и нужно редактировать функцию `IsCameraLookAt_Callback` раздела `USER EDITABLE FUNCTIONS` внутри файла. Стоит также ознакомиться с триггером `IsCameraLookAt_VectorDrawer`.

> [!TIP]
> Вы можете скроллить код ниже вправо и влево! Наведите курсор на полотно и колесиком мыши с помощью `shift` двигайте его!

```c
Class I3D
{
    /* Расширенное манипулирование 3D пространством */

    [M] table Positions SetObjectsAroundCircle( table ListOfObjects, CVector CenterPos, Quaternion BaseRotation, float Radius, float StartAngleDeg, bool or Quaternion LookOutside, bool AutoRadius, bool PosAbsolute )
    /* Размещает выбранные объекты ListOfObjects по окружности
       в позиции CenterPos и вращением орбиты BaseRotation
       с начальным радиусом Radius,
       с углом смещения первого объекта по орбите на StartAngleDeg.

       Объекты смотрят наружу, если LookOutside = true,
       иначе внутрь, можно передать Quaternion для своего вращения.

       Объекты размещаются с динамическим радиусом,
       зависящим от длины конкретного объекта,
       если AutoRadius = true,
       иначе выравнивание по длине первого объекта в списке
       (чтобы не спавнились друг в друге).

       Размещает объекты с фиксированной высотой,
       если PosAbsolute = true,
       иначе на ландшафте. */

    [M] Quaternion SetObjectLookAt( object SetAim, object GetAim, bool OnlyYaw, bool LockRoll )
    /* Обращает взор первого объекта на позицию второго объекта —
       как аим камеры в катсценах.

       Для плавной работы необходимо вызывать каждый раз.

       objSetAim    = объект, который нужно повернуть.
       objGetAim    = объект или позиция, на которую надо "смотреть": может быть getObj(), CVector(), GetCameraPos().
       boolOnlyYaw  = применяется вращение только по оси Y (как турель), если true.
       boolLockRoll = запрещается вращение по оси Z (наклон), если true.

       Примеры:

       SetObjectLookAt(getObj("aim_object_name"), GetPlayerVehicle(), false, true)
       --> Аим на объект.
       SetObjectLookAt(getObj("aim_object_name"), GetCameraPos(), false, true)
       --> Аим на камеру. */

    [M] void IsCameraLookAt( float DrawVectorQuant, float DrawVectorQuantMultiplier, float DrawVectorMinDistance, float DrawVectorMaxDistance, float DrawCatchZoneSize )
    /* Смотрит ли куда-то камера?

       Бросает луч из камеры и пытается что-то "нащупать"
       (работает с триггером "IsCameraLookAt_VectorDrawer"
       или с IsCameraLookAt_VectorDrawer_f()).

       float DrawVectorQuant           = шаг построения отрезка луча (в метрах).
       float DrawVectorQuantMultiplier = множитель шага построения отрезка луча (1.0).
       float DrawVectorMinDistance     = минимальное расстояние, после которого идет захват объекта лучом (в метрах).
       float DrawVectorMaxDistance     = максимальное расстояние захвата объектов лучом (в метрах).
       float DrawCatchZoneSize         = размер зоны захвата объектов в точке луча (в метрах).

       Оригинальный lookAt у [GetCameraPos()] сломан.

       Пример использования:
       I3D:IsCameraLookAt(5,1,20,1000,5) */

    [M] ??? IsCameraLookAt_Callback( CVector pos, Object entity )
    /* Настраивается пользователем.

       Эта callback-функция вызывается I3D.LookAtProcess,
       когда он завершается.

       Нужна как обработка ивента окончания работы луча.

       Аргументы возвращает сам I3D.LookAtProcess:
           pos    = CVector точки, куда смотрела камера на момент вызова IsCameraLookAt().
           entity = Object сущности, какую захватил луч, может быть nil.

       Доступен такой же контроль, как через GetEntityByName(). */

    [M] bool IsInCameraView( CVector pos, table region )
    /* Находится ли точка в поле зрения камеры.

       Границы захвата на экране:
           region = { left, right, bottom, top }

       Значения пропорциональны и находятся в диапазоне от -1 до 1. */

    [M] bool IsInCameraViewSquared( CVector pos, float ScopeCoeff )
    /* Находится ли точка в поле зрения камеры.

       Границы захвата на экране
       в квадратном соотношении
       с ScopeCoeff (от -1 до 1). */

    [M] bool IsObjectInCameraView( object Entity, float ScopeCoeff, bool SquareScope )
    /* Находится ли объект в поле зрения камеры.

       Объединяет между собой
       [IsInCameraViewSquared()]
       и [IsInCameraView()].

       Entity     = объект как getObj() или GetEntityByName().
       ScopeCoeff = коэффициент размера зоны захвата на экране (от 0 до 1, где 1 = весь экран).
             Может быть как:
                 region = { left, right, top, bottom }
             со значениями от -1 до 1.
       SquareScope = квадратное соотношение зоны захвата, если true. */

    [M] bool IsObjectInsideLocation( string LocationName, object Object, float MinLength )
    /* Находится ли объект в локации.

       Удобная проверка когда, например,
       в локацию попадает игрок,
       а не караван его белонга.

       LocationName = имя локации.
       Object = объект/машина.
       MinLength = минимальное безопасное расстояние до локации, 5 метров если nil. */

    [M] CVector RotateAroundPoint( CVector 1, CVector 2, Quaternion or tableRotation )
    /* Возвращает точку повернутого вектора2 вокруг вектора1
       на угол tableRotation [{90,0,0}]
       или Quaternion(). */

    [M] CVector LinearMoveAroundPoint( CVector 1_old, CVector 1_new, CVector 2_old )
    /* Возвращает точку сдвинутого вектора2
       линейно вместе с вектором1.

       1_old = последняя сохраненная позиция вектора1.
       1_new = новая позиция вектора1.
       2_old = последняя сохраненная позиция вектора2. */

    [M] CVector AdjustDistanceBetweenVectors( CVector 1_old, CVector 2_old, float target_dist )
    /* Возвращает точку вектора2 на нужном расстоянии от вектора1.

       1_old       = последняя сохраненная позиция вектора1.
       2_old       = последняя сохраненная позиция вектора2.
       target_dist = требуемое расстояние между векторами. */

    [M] CVector GetEndOfBeam( CVector origin, Quaternion, float distance )
    /* Возвращает точку на расстоянии distance от origin,
       направленную по вращению quaternion. */

    [M] CVector&boolObstacle DrawVector( CVector origin, Quaternion, float distance )
    /* Рисует вектор в игровом мире длиной distance от origin,
       направленного по вращению quaternion,
       и возвращает его вторую точку.

       Воспринимает препятствия
       в виде ландшафта
       и края карты. */

    [M] Quaternion QuaternionFromTo( CVector From, CVector To )
    /* Возвращает кватернион от вектора к вектору
       (вращение из одного направления
       в другое). */

    [M] Quaternion QuaternionByLandscape( CVector vec, Quaternion rot )
    /* Возвращает кватернион по уровню ландшафта.

       Выравнивает объект по ландшафту,
       чтобы он не был строго в горизонте. */

    [M] CVector RotateCVectorByQuaternion( CVector, Quaternion )
    /* Возвращает точку помноженного вектора на кватернион
       (поворот CVector по вращению Quaternion). */

    [M] CVectorX&CVectorY&CVectorZ QuaternionToAxes( Quaternion )
    /* Возвращает направления по осям из кватерниона. */

    [M] Quaternion QuaternionFromAxes( CVector right, CVector up, CVector forward )
    /* Возвращает кватернион из направлений по осям. */

    [M] CVector GetForwardFromQuaternion( Quaternion )
    /* Возвращает направление "вперед" из вращения. */

    [M] CVector CVectorAverage( table Positions, bool Y )
    /* Возвращает точку как среднее арифметическое векторов.

       Считает Y, если true. */

    [M] Objects CallEntityInZone( CVector pos, float ZoneSize, bool GetsIntoCamera )
    /* Возвращает объект(ы), что находится в желаемой точке:

       CVector pos         = CVector точки, позиция камеры если nil;
       float ZoneSize      = размер зоны у точки, в которой может быть объект (в метрах);
       bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true;

       Получит объекты карты снова, если GetAllEntitiesAgain = true;

       Передайте AnythingInZone = true, чтобы функция вернула все найденные объекты
            или функцию Condition для настройки фильтра
            например [I3D.IsVehicleWithBelong] и аргумент для нее FunctionConditionArgument, например [1004].

       Примеры:
            local objects = I3D:CallEntityInZone(GetCameraPos(), 5, true, false, I3D.IsVehicleWithBelong, 1004)
            local obj = I3D:CallEntityInZone(CVector(627, 228, -627), 10, true, true) */

    [M] table GetAllEntities( bool GetsIntoCamera )
    /* Возвращает все объекты на карте, что имеют позиции CVector, и их количество.

       bool GetsIntoCamera = захватывает только объекты в поле зрения камеры, если true. */

    [M] void ClearAllCachedEntities()
    /* Очищает все закэшированные объекты, которые получили [CallEntityInZone] и [GetAllEntities]

       для лечения возможных проблем при их переборе в циклах */


    /* Функции-фильтры для [I3D:CallEntityInZone()]. Вы можете аналогично добавить свои */

    [M] bool IsVehicle( object )
    [M] bool IsVehicleWithName( object, string Name )
    [M] bool IsVehicleWithBelong( object, int Belong )
    [M] bool IsVehicleWithPrototype( object, string Prototype )


    /* Помощь в расчетах */

    [M] void p()
    /* Аналог встроенной функции Targem p().

       Печатает Point движения камеры в .log
       в формате camera_paths.xml
       без разделителей-запятых. */

    [M] bool IsCVector( userdata )
    /* Является ли userdata
       объектом типа CVector. */

    [M] bool IsQuaternion( userdata )
    /* Является ли userdata
       объектом типа Quaternion. */

    [M] string IsUserdata( userdata )
    /* Определяет тип userdata.

       Объединяет в себе
       [IsCVector()]
       и [IsQuaternion()].

       Возвращает:
           "cvector"
           "quaternion"
           "userdata"
           "not userdata"

       Если возможно,
       иначе возвращает имя класса объекта. */

    [M] table UpdateScreenInfo()
    /* Обновляет информацию о параметрах экрана.

       Возвращает таблицу:
           fov
           width
           height */

    [M] table CollectExternalPaths( string PathNamePrefix, string CollectPostfix )
    /* Собирает все External Path на карте.

       Возвращает таблицу путей
       и выводит их имена в .log.

       PathNamePrefix = любой префикс имени.
       CollectPostfix = начальный цифровой постфикс.

       Например:
           PathNamePrefix = "pathName"
           CollectPostfix = "_0"

       Будут найдены:
           pathName_0
           pathName_1
           pathName_2
           ... */

    [M] table CollectCameraPaths( string PathNamePrefix, string CollectPostfix )
    /* Собирает все Camera Path на карте.

       Возвращает таблицу путей
       и выводит их имена в .log.

       PathNamePrefix = любой префикс имени.
       CollectPostfix = начальный цифровой постфикс.

       Например:
           PathNamePrefix = "pathName"
           CollectPostfix = "_0"

       Будут найдены:
           pathName_0
           pathName_1
           pathName_2
           ... */

    [M] int MoveObject( object Entity, string PathName, float MoveTime, string MoverName )
    /* Создает cinematicMover с именем MoverName
       и возвращает его ID.

       Entity начинает движение по пути PathName
       продолжительностью MoveTime секунд. */

    [M] void MoveObjectsByPaths( table Objects, table PathNames, float MoveTime, string MoverName )
    /* Одновременно запускает движение нескольких объектов.

       Каждый объект движется по соответствующему пути
       из таблицы PathNames.

       Является удобной оберткой над MoveObject().

       Количество объектов и путей должно совпадать. */

    [M] CVector GetCameraPos()
    /* Обертка над стандартной функцией GetCameraPos().

       Всегда возвращает позицию как CVector. */

    [M] Quaternion GetCameraRot()
    /* Возвращает исправленное вращение камеры,
       полученное через GetCameraPos().

       Оригинальное вращение камеры зеркалится на полюсах.

       Для камер катсцен это работает правильно,
       но для обычных объектов приводит к неправильному вращению. */

    [M] CVector GetCameraPosLinked( object Object, bool LOG )
    /* Возвращает позицию камеры относительно объекта или машины.

       Используется для FlyLinked.

       Принтит в лог результат, если bool LOG = true. */

    [M] CVector GetCVectorDifference( CVector origin, CVector linkedPosition )
    /* Возвращает разницу между двумя позициями CVector. */

    [M] CVector ParseCVector( string CVector )
    /* Преобразует строку в объект CVector. */

    [M] Quaternion ParseQuaternion( string Quaternion )
    /* Преобразует строку в объект Quaternion. */

    [M] table Positions ItemsToCVectors( table Items )
    /* Преобразует список с объектами в таблицу их позиций CVector.

       Каждый элемент может быть:
           "MyVehicleName"
           getObj(...)
           "1 2 3"
           CVector(1,2,3) */

    [M] table Objects CollectVehiclesByTeam( string TeamName )
    /* Возвращает таблицу машин указанной команды.

       TeamName = имя команды. */

    [M] table Objects CollectObjects( table ObjectNamesOrIDs )
    /* Возвращает таблицу объектов, найденных по списку.

       Каждый элемент списка может быть:
           - именем объекта;
           - ID объекта. */

    [M] Quaternion EulerToQuaternion( float x, float y, float z, bool LOG )
    /* Преобразует углы Эйлера в Quaternion.

       x = угол по оси X.
       y = угол по оси Y.
       z = угол по оси Z.
       LOG = выводит результат в .log, если true. */

    [M] floatX&floatY&floatZ QuaternionToEuler( Quaternion, bool LOG )
    /* Преобразует Quaternion в углы Эйлера.

       LOG = выводит результат в .log, если true.

       Возвращает:
           X
           Y
           Z */

    [M] Quaternion GetFixedQuaternion( Quaternion )
    /* Возвращает исправленный Quaternion.

       Полезно в случаях,
       когда вращение объекта оказывается зеркальным
       или направлено в противоположную сторону. */

    [M] float CVectorDot( CVector 1, CVector 2 )
    /* Возвращает скалярное произведение двух векторов. */

    [M] CVector CVectorCross( CVector 1, CVector 2 )
    /* Возвращает векторное произведение двух векторов. */

    [M] CVector CVectorNormalize( CVector )
    /* Возвращает нормализованный CVector. */

    [M] int GetMapSize()
    /* Возвращает размер карты в метрах. */


    /* Внутренние функции. По возможности не используйте. */

    [M] CVector&Object IsCameraLookAt_VectorDrawer_f()
    /* Функциональная альтернатива
       триггеру "IsCameraLookAt_VectorDrawer".

       Плюсы:
           - луч обрабатывается мгновенно.
       Минусы:
           - лагает, Ex Machina не вывозит. */

    [M] Quaternion CVectorEulerToQuaternion( float pitch, float yaw, float roll, bool LOG )
    /* Преобразует углы Эйлера в Quaternion.

       LOG = выводит результат в .log, если true.

       Возвращает:
           pitch = Y
           yaw   = Z
           roll  = X */

    [M] floatX&floatY&floatZ CVectorQuaternionToEuler( Quaternion, bool LOG )
    /* Преобразует Quaternion в углы Эйлера.

       LOG = выводит результат в .log, если true.

       Возвращает:
           pitch = Y
           yaw   = Z
           roll  = X */
}
```

<a id="aboutCVectorAndQuaternion_ru"></a><a href="#top">Наверх ↑</a>

## Что такое "координаты"
В игре координатами являются три числовых значения, которые **задают точку в пространстве** на игровом уровне и измеряются в метрах: `x` `y` `z`, где `x` - запад/восток; `y` - вверх/вниз; `z` - север/юг. Координаты отсчитываются от левого нижнего края игрового уровня (юго-запад) и зависят от его размера.

- Вид координат: `CVector(1,2,3)` - `1`=`x`, `2`=`y` и `3`=`z`.

## Что такое "вращение"
В игре вращением является система правонаправленного кватерниона, содержащего четыре числовых значения, который **задает вращение в пространстве**: `x` `y` `z` `w`, где `x` - вращение по оси `x`; `y` - вращение по оси `y`; `z` - вращение по оси `z`; `w` - вращение на угол θ (тэта). Значения могут быть от `-1` до `1`. Кватернион считается по синусам и косинусам половин углов в радианах по формулам. *Improved3D позволяет вам считать углы Эйлера по трем осям в углы кватерниона и наоборот.*

- Вид вращения: `Quaternion(0,0,0,1)` - нули для осей `x` `y` `z` и `1` для поворота θ - север (`0` для поворота θ - юг, инверсия): **объект смотрит ВПЕРЕД по оси Z на север карты**.

## Что такое "направление"
В игре направлением является вектор координат `CVector`, который **задает направление в пространстве**. Значения осей `x` `y` `z` складываются и получается вектор с нужным направлением и длиной (силой). Любой физический объект в игре содержит информацию о своем направлении (движении), даже если он стоит на месте. Расчет направлений необходим для смещения точек и вращений относительно друг друга.

- Вид направления: `CVector(0,0,1)` - вектор направлен на север карты; `CVector(0,1,0)` - вектор направлен вверх; `CVector(1,0,0)` - вектор направлен на восток карты.

<a id="triggerIsCameraLookAt_ru"></a><a href="#top">Наверх ↑</a>

## Триггер `IsCameraLookAt_VectorDrawer`
Нужен для функции `IsCameraLookAt`

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
            coroutine.resume(I3D.LookAtProcess, pos, entity)
            trigger:Deactivate()
        end
    </script>
</trigger>
```

<a id="howToDoFlyingObject_ru"></a>

## Как сделать летающий объект, как на гифке

Я вам просто покажу триггеры, которые я использовал для этой демонстрации, но добавлю комментарии с пояснениями:

```xml
<trigger Name="a" active="0">
    <event timeout="1" eventid="GE_TIME_PERIOD" />
	<script>
        --Включив полет камеры, выставляю точку в пространстве, где хочу заспавнить машину/объект.
		--Запускаю триггер в консоли.
        --Позицию камеры я записываю в глобальную переменную:
        GL_gde = GetCameraPos()

        --Затем создаю в этой точке Урал:
        TeamCreate("aimteam", 1004, GL_gde, Quaternion(0,0,0,1), {"Ural01"})

        --Потом включаю триггер для "слежки", а этот выключаю:
        TActivate("aim")
        trigger:Deactivate()
    </script>
</trigger>

<trigger Name="aim" active="0">
    <event timeout="0" eventid="GE_TIME_PERIOD" />
    <script>
        --Так как я создал Урал - он падает вниз по законам физики.
        --Для статических объектов это не нужно...
        --После включения этого триггера, он "ловит" падающий объект,
        --И вновь назначает ему позицию, в которой он был создан
        --Без всяких проверок, потому что это для демонстрации:
        getObj("aimteam_vehicle_0"):SetPosition(GL_gde)
		
		--Чтобы объект мог двигаться в стороны, а не быть в одной точке,
		--Можно применять к нему только определенные координаты, например Y:
		--local gde = getObj("aimteam_vehicle_0"):GetPosition()
		--getObj("aimteam_vehicle_0"):SetPosition(gde.x, GL_gde.y, gde.z)
		
		--А чтобы он мог летать с фиксированной высотой над ландшафтом:
		--local gde = getObj("aimteam_vehicle_0"):GetPosition()
		--gde.y = g_ObjCont:GetHeight(gde.x, gde.z) + 11 --желаемая высота в метрах!
		--getObj("aimteam_vehicle_0"):SetPosition(gde)

        --После "подвешивания" объекта "за шкирку" вызываю I3D:SetObjectLookAt,
        --Который через println принтит в консоль вращение "взгляда", вы можете тоже за этим понаблюдать:
        println(I3D:SetObjectLookAt(getObj("aimteam_vehicle_0"), GetPlayerVehicle(), false, true))
        --Если вы еще не знаете как эта функция работает, найдите ее в разделе "ФУНКЦИИ И МЕТОДЫ".
		--Вы можете писать другие функции I3D для создания какого-то другого движения
		--Или двигать объект импульсами через SetCustomLinearVelocity...

        --Обратите внимание, что я не отключаю этот триггер - он работает бесконечно!
        --Вам нужно будет придумать варианты его отключения, если необходимо...
    </script>
</trigger>
```

<a id="detailsAndThanks_ru"></a><a href="#top">Наверх ↑</a>

## ПОДРОБНЕЕ

Эту и другую информацию вы сможете найти в файле проекта или найти примеры работы модуля в моде ExplorerMod от того же автора.

О игровых картах вы можете посмотреть в *[обучающей статье на DeusWiki](https://deuswiki.com/w/Участник:Axeble)* от того же автора.


## КОММЕНТАРИИ АВТОРА

    E Jet: Спасибо нашим поварам за то, что вкусно варят нам!

## Благодарность 

- ***crtvxxx*** за помощь с `math.`! В импортированной функции из ExplorerMod на спавн по окружности я впервые столкнулся с проблемой МАТЕМАТИКИ! Пусть функция и была переписана полностью, но уважение вечно! Этот парень выручил целую фичу!
- ***Rusya_27*** за обратную связь и выявление багов!
- ***Gnome627*** за функцию `I3D:p()`!
- ***Varisane*** за обратную связь!

<a href="#top">Наверх ↑</a>

----

----

<a id="wtf_en"></a>

## WHAT IS IT

A universal lua module that can be used to **expand the possibilities** for "space manipulation" in the game.

You will be able to more **flexibly calculate coordinates and rotation, conveniently PLACE and ROTATE objects**, and use some technical features **through scripts** of any modification inside the game.

> The task of the lua-module is to somehow simplify the work of community members in creating modifications if it is difficult for them to implement something on their own.

### FEATURES
- **Full control of the `Quaternion` rotation** - now you don't have to guess what those numbers are! It is enough for you to imagine degrees on three axes `x` `y` `z`!
- **Full control of the `CVector` coordinates** - easily move and place objects relative to each other!
- **Interaction with the game camera** - you can find out where she is looking and what is in her field of vision!
- **Placing objects around a circle** with any desired rotation is a great solution for small gang cars and `FlyAround`!
- **Turning an object in any direction** - now *not only the camera* can be used in cutscenes!
- Recording coordinates and rotation for cars with a game camera - in the original, the camera had a *broken* rotation, it only turned out to be another car/object!
- Collecting cars by their `team` name, objects by name/ID in one convenient list!
- A set of commands for convenient calculation of coordinates, rotation, vectors in space for your scripts - save time!
- Other small and useful scripts!

<a id="allAboutIt_en"></a><a href="#top">Go up ↑</a>

### Disclaimer

THE AUTHOR OF THIS CREATION THINKS HE KNOWS HOW TO PROPERLY NAME AND USE THINGS IN PROGRAMMING, SO A REQUEST FOR HEALTHY PROGRAMMERS IS TO UNDERSTAND AND FORGIVE IF THERE IS SOMETHING (EVERYTHING) HERE NOT LIKE THAT.


THE AUTHOR UNDERSTANDS AND ACCEPTS THAT ALL THE CODE BELOW AND THIS TEXT IS POORLY WRITTEN, INCOMPREHENSIBLE AND CUMBERSOME, THAT EVEN THIS LESSON DOES NOT MAKE THE SLIGHTEST SENSE - AS WELL AS THE MEANING IN THIS CAPSULE DISCLAIMER.


THE LUA MODULE IS FREELY DISTRIBUTED "AS IS" AND IS USED BY THE GAME EX MACHINA / HARD TRUCK APOCALYPSE AND CAN BE MODIFIED BY ANY OTHER USER (MODDER) INSIDE THEIR OWN MODIFICATIONS AND OTHER RESOURCES.

THE AUTHOR IS NOT RESPONSIBLE FOR ANY CONSEQUENCES RESULTING IN DAMAGE DURING THE USE OF THIS, AS WELL AS ANY OTHER, INCLUDING MODIFIED VERSIONS OF THE LUA MODULE OR PARTS OF THE CODE BORROWED (REWRITTEN) FROM THIS FILE.

## HOW TO USE IT

Why is this a "module" and not any other lua script file? Although it is...
- Because this file is an I3D function table (hereinafter referred to as the class), which has its own methods and functions, which is very similar to a serious topic. Probably. Like. I don't know...

### INSTALLATION

This craft is still far from being a full-fledged lua module, so it does not need to be installed as a Lua library in the system.

This lua module is loaded into the game in two ways: via `require()` or `dofile()`. These are the internal Lua commands of the game. 
Our familiar `EXECUTE_SCRIPT` won't do, as it doesn't return a module object.


What is the difference between `require()` and `dofile()`? 


- `require()` loads the file into the game at the first execution and holds it in the game's memory until restarting. This command is used to load modules of a healthy person, which are installed into the system (but not necessarily);
- `dofile()` loads a file into the game's memory as many times as it was called. The entire internal cache of the lua module is cleared and the default settings are accepted. It is recommended for debugging and other debugging.

I recommend writing the command at the end of the `server.lua` file of the game, since commands that are loaded into the game a little earlier than the server can be used in the module ("can"? the author is Alzheimer's!).


The local path to the module file is specified as the function argument.


The returned table is placed in a global variable, which will be used as an object to which the methods (functions) of this module will be applied separated by a colon. 

To make it clearer, let's recall how we refer to the player's vehicle:
```lua
local Plv = GetPlayerVehicle()
if Plv then
    Plv:SetSkin(1)  --> method per object
end
```
Or object container:
```lua
local Gde = CVector(1,2,3)
local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> method per object
```

After loading the module into the game, you can already start using its methods and global commands.

### Sample load code

```lua
--server.lua
I3D = require("data\\gamedata\\lua_lib\\improved3d.lua")
if not I3D then
    LOG("[E] Could not find global Improved3D.lua...")
end
```

### Sample use code
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

## SAFETY PRECAUTIONS

- ***RECOMMENDED*** to read the notes below before working ***[What are "coordinates"]***, ***[What is "rotation"]*** and ***[What is "direction"]*** in the understanding of the game and this the lua module. *Otherwise, the warranty for proper operation is void.*

- ***FORBIDDEN*** to use this lua module in your mods without attribution. Otherwise, I'll set off a spell and conjure up a week's diarrhea. 
*A joke 💋*

<a id="allFunctions_en"></a><a href="#top">Go up ↑</a>

## FUNCTIONS AND METHODS

All the public functions of this module are collected here. Each function has a detailed description of what it does and what to specify in it.

> [!IMPORTANT]
> The standard rotation is `Quaternion(0,0,0,1)` or *`Euler(0,0,0)` - **the object looks FORWARD on the Z axis to the north of the map**, any rotation is based from this direction. This should be kept in mind when writing scripts. (\**Euler(0,0,0)* is not a function, just a visual comparison.)
> 
> To configure the operation of `IsCameraLookAt`, you can and should edit the `IsCameraLookAt_Callback` function of the `USER EDITABLE FUNCTIONS` section inside the file. It is also worth familiarizing yourself with the `IsCameraLookAt_VectorDrawer` trigger.

> [!TIP]
> You can scroll the code below to the right and left! Hover the cursor over the canvas and use the mouse wheel to move it using `shift`!

```c
Class I3D
{
    /* Advanced 3D Space Manipulation */

    [M] table Positions SetObjectsAroundCircle( table ListOfObjects, CVector CenterPos, Quaternion BaseRotation, float Radius, float StartAngleDeg, bool or Quaternion LookOutside, bool AutoRadius, bool PosAbsolute )
    /* Places the objects from ListOfObjects around a circle centered at CenterPos using the orbit rotation BaseRotation and the initial radius Radius. The first object is offset along the orbit by StartAngleDeg degrees.
       Objects face outward if LookOutside = true, otherwise inward. You may also pass a Quaternion instead of a boolean to specify a custom rotation.
       If AutoRadius = true, the radius is dynamically adjusted according to the length of each individual object. Otherwise, the spacing is based on the length of the first object in the list to prevent objects from overlapping.
       If PosAbsolute = true, objects are placed at a fixed height. Otherwise, they are aligned to the terrain. */

    [M] Quaternion SetObjectLookAt( object SetAim, object GetAim, bool OnlyYaw, bool LockRoll )
    /* Rotates the first object so that it looks at the second object or position, similar to camera aiming in cutscenes.
       For smooth tracking, this function should be called every frame.

       SetAim   - object to rotate.
       GetAim   - object or position to look at. Can be getObj(), CVector(), or GetCameraPos().
       OnlyYaw  - if true, rotation is applied only around the Y axis (turret-like behavior).
       LockRoll - if true, prevents rotation around the Z axis (roll).

       Examples:
       SetObjectLookAt(getObj("aim_object_name"), GetPlayerVehicle(), false, true) --> Aim at an object.
       SetObjectLookAt(getObj("aim_object_name"), GetCameraPos(), false, true) --> Aim at the camera. */

    [M] void IsCameraLookAt( float DrawVectorQuant, float DrawVectorQuantMultiplier, float DrawVectorMinDistance, float DrawVectorMaxDistance, float DrawCatchZoneSize )
    /* Checks whether the camera is looking at something.
       Casts a ray from the camera and attempts to detect an entity. Works together with the "IsCameraLookAt_VectorDrawer" trigger or the IsCameraLookAt_VectorDrawer_f() function.

       float DrawVectorQuant            - ray construction step in meters.
       float DrawVectorQuantMultiplier  - ray step multiplier (default 1.0).
       float DrawVectorMinDistance      - minimum distance before object detection starts (meters).
       float DrawVectorMaxDistance      - maximum ray distance for object detection (meters).
       float DrawCatchZoneSize          - detection radius around the ray endpoint (meters).

       The original lookAt implementation used by [GetCameraPos()] is broken.

       Example:
       I3D:IsCameraLookAt(5,1,20,1000,5) */

    [M] ??? IsCameraLookAt_Callback( CVector pos, Object entity )
    /* User-defined callback.
       Invoked by I3D.LookAtProcess when ray processing is finished.

       Arguments:
       pos    - CVector representing the point where the camera was looking when [IsCameraLookAt()] was called.
       entity - Object hit by the ray, or nil if nothing was detected.

       Provides the same level of access as GetEntityByName(). */

    [M] bool IsInCameraView( CVector pos, table region )
    /* Returns true if the specified point is inside the camera view.
       The screen region is defined proportionally by region = { left, right, bottom, top }, where each value ranges from -1 to 1. */

    [M] bool IsInCameraViewSquared( CVector pos, float ScopeCoeff )
    /* Returns true if the specified point is inside a square camera view region.
       ScopeCoeff defines the square capture area in the range from -1 to 1. */

    [M] bool IsObjectInCameraView( object Entity, float ScopeCoeff, bool SquareScope )
    /* Returns true if the specified object is visible by the camera.
       Combines [IsInCameraViewSquared()] and [IsInCameraView()].

       Entity      - object returned by getObj() or GetEntityByName().
       ScopeCoeff  - size of the capture region on the screen (0..1, where 1 represents the entire screen).
                     Can also be a region table { left, right, top, bottom } with values from -1 to 1.
       SquareScope - if true, uses a square capture region. */

    [M] bool IsObjectInsideLocation( string LocationName, object Object, float MinLength )
    /* Returns true if the specified object is inside the given location.
       Useful when, for example, you need to check whether the player has entered a location
       rather than the player's convoy or belong.

       LocationName - location name.
       Object       - object or vehicle to test.
       MinLength    - minimum safe distance from the location boundary.
                      Defaults to 5 meters if nil. */

    [M] CVector RotateAroundPoint( CVector 1, CVector 2, Quaternion or tableRotation )
    /* Returns the position of vector2 rotated around vector1.
       Rotation can be specified either as a table of Euler angles
       (for example {90, 0, 0}) or as a Quaternion. */

    [M] CVector LinearMoveAroundPoint( CVector 1_old, CVector 1_new, CVector 2_old )
    /* Returns the new position of vector2 after vector1 has been moved linearly.

       1_old - previous position of vector1.
       1_new - new position of vector1.
       2_old - previous position of vector2. */

    [M] CVector AdjustDistanceBetweenVectors( CVector 1_old, CVector 2_old, float target_dist )
    /* Returns a new position for vector2 so that it is located at the specified distance
       from vector1.

       1_old       - position of vector1.
       2_old       - position of vector2.
       target_dist - desired distance between the vectors. */

    [M] CVector GetEndOfBeam( CVector origin, Quaternion, float distance )
    /* Returns the endpoint located at the specified distance from origin
       in the direction defined by the quaternion. */

    [M] CVector&boolObstacle DrawVector( CVector origin, Quaternion, float distance )
    /* Draws a vector in the game world starting from origin and extending
       by the specified distance in the direction of the quaternion.

       Returns the endpoint of the vector.
       Detects collisions with terrain and map boundaries. */

    [M] Quaternion QuaternionFromTo( CVector From, CVector To )
    /* Returns a quaternion representing the rotation from one direction vector
       to another. */

    [M] Quaternion QuaternionByLandscape( CVector vec, Quaternion rot )
    /* Returns a quaternion aligned to the terrain surface.

       Useful for spawning objects so they follow the terrain slope instead of
       remaining perfectly horizontal. */

    [M] CVector RotateCVectorByQuaternion( CVector, Quaternion )
    /* Rotates a CVector by the specified quaternion and returns the resulting vector. */

    [M] CVectorX&CVectorY&CVectorZ QuaternionToAxes( Quaternion )
    /* Converts a quaternion into its local axis vectors
       (right, up, and forward). */

    [M] Quaternion QuaternionFromAxes( CVector right, CVector up, CVector forward )
    /* Creates a quaternion from the specified local axis vectors
       (right, up, and forward). */

    [M] CVector GetForwardFromQuaternion( Quaternion )
    /* Returns the forward direction vector represented by the quaternion. */

    [M] CVector CVectorAverage( table Positions, bool Y )
    /* Returns the arithmetic mean of all vectors in the table.

       If Y is true, the Y coordinate is included in the calculation.
       Otherwise, averaging is performed only on the horizontal plane. */

    [M] Objects CallEntityInZone( CVector pos, float ZoneSize, bool GetsIntoCamera )
    /* Returns the object(s) that is located at the desired point:

       CVector pos         = CVector of the point, camera position if nil;
       float ZoneSize      = the size of the zone at the point where the object can be located (in meters);
       bool GetsIntoCamera = captures only objects that can be in front of the camera if true;

       Will get the map objects again if GetAllEntitiesAgain = true;

       Pass AnythingInZone = true so that the function returns all found objects.
            or the Condition function for configuring the filter
            for example [I3D.IsVehicleWithBelong] and the argument for it is FunctionConditionArgument, for example [1004].

       Examples:
            local objects = I3D:CallEntityInZone(GetCameraPos(), 5, true, false, I3D.IsVehicleWithBelong, 1004)
            local obj = I3D:CallEntityInZone(CVector(627, 228, -627), 10, true, true) */

    [M] table GetAllEntities( bool GetsIntoCamera )
    /* Returns all the objects on the map that have CVector positions and their number.

       bool GetsIntoCamera = captures only objects in the camera's field of view, if true. */

    [M] void ClearAllCachedEntities()
    /* Clears all cached objects that have received [CallEntityInZone] and [GetAllEntities]

       to treat possible problems when iterating through them */


    /* Filter-functions for [I3D:CallEntityInZone()]. You can similarly add your own */

    [M] bool IsVehicle( object )
    [M] bool IsVehicleWithName( object, string Name )
    [M] bool IsVehicleWithBelong( object, int Belong )
    [M] bool IsVehicleWithPrototype( object, string Prototype )


    /* Calculation Helpers */

    [M] void p()
    /* Equivalent of Targem's built-in p() function.

       Prints a camera movement Point to the game log in the format used by
       camera_paths.xml, without comma separators. */

    [M] bool IsCVector( userdata )
    /* Returns true if the specified userdata is a valid CVector. */

    [M] bool IsQuaternion( userdata )
    /* Returns true if the specified userdata is a valid Quaternion. */

    [M] string IsUserdata( userdata )
    /* Determines the type of the specified userdata.

       Combines the functionality of [IsCVector()] and [IsQuaternion()].

       Returns one of the following strings:
           "cvector"
           "quaternion"
           "userdata"
           "not userdata"

       Or returns the object's class name. */

    [M] table UpdateScreenInfo()
    /* Updates the module's cached screen information.

       Returns a table containing:
           fov
           width
           height */

    [M] table CollectExternalPaths( string PathNamePrefix, string CollectPostfix )
    /* Collects all External Paths from the current map.

       Returns the resulting table and prints the collected path names
       to the game log.

       PathNamePrefix may be any string.

       CollectPostfix must contain the starting numeric suffix.

       Example:
           PathNamePrefix = "pathName"
           CollectPostfix = "_0"

       Produces:
           pathName_0
           pathName_1
           pathName_2
           ... */

    [M] table CollectCameraPaths( string PathNamePrefix, string CollectPostfix )
    /* Collects all Camera Paths from the current map.

       Returns the resulting table and prints the collected path names
       to the game log.

       PathNamePrefix may be any string.

       CollectPostfix must contain the starting numeric suffix.

       Example:
           PathNamePrefix = "pathName"
           CollectPostfix = "_0"

       Produces:
           pathName_0
           pathName_1
           pathName_2
           ... */

    [M] int MoveObject( object Entity, string PathName, float MoveTime, string MoverName )
    /* Creates a cinematicMover named MoverName and returns its ID.

       Entity begins moving along the specified camera path PathName
       and completes the movement in MoveTime seconds. */

    [M] void MoveObjectsByPaths( table Objects, table PathNames, float MoveTime, string MoverName )
    /* Moves multiple objects simultaneously.

       Each object follows the corresponding path from PathNames.

       This is a convenience wrapper around [MoveObject()].

       The number of objects and path names must be identical. */

    [M] CVector GetCameraPos()
    /* Wrapper around the standard [GetCameraPos()] function.

       Always returns the position as a CVector. */

    [M] Quaternion GetCameraRot()
    /* Returns the corrected camera rotation derived from [GetCameraPos()].

       The original camera rotation is mirrored around the poles.
       While this behavior works correctly for cutscene cameras,
       it produces incorrect rotations when applied to ordinary objects. */

    [M] CVector GetCameraPosLinked( object Object, bool LOG )
    /* Returns the camera position relative to the specified object or vehicle.

       Useful for FlyLinked and similar camera systems.

       LOG - if true, prints the resulting Euler angles
             to the game log. */

    [M] CVector GetCVectorDifference( CVector origin, CVector linkedPosition )
    /* Returns the difference vector between two CVector positions. */

    [M] CVector ParseCVector( string CVector )
    /* Parses a CVector from its string representation.

       Returns the corresponding CVector userdata. */

    [M] Quaternion ParseQuaternion( string Quaternion )
    /* Parses a Quaternion from its string representation.

       Returns the corresponding Quaternion userdata. */

    [M] table Positions ItemsToCVectors( table Items )
    /* Converts a collection of mixed values into a table of CVector objects.

       Supported input types include:
           "MyVehicleName"
           getObj(...)
           "1 2 3"
           CVector(1,2,3) */

    [M] table Objects CollectVehiclesByTeam( string TeamName )
    /* Returns a table containing all vehicles found in the specified team.

       TeamName - name of the team to search. */

    [M] table Objects CollectObjects( table ObjectNamesOrIDs )
    /* Returns a table containing all objects found in the provided list.

       Each element may be either:
           - an object name
           - an object ID */

    [M] Quaternion EulerToQuaternion( float x, float y, float z, bool LOG )
    /* Converts Euler angles (in degrees) to a quaternion.

       x, y, z - Euler rotation angles.
       LOG     - if true, prints the resulting quaternion
                 to the game log.

       Returns the generated Quaternion. */

    [M] floatX&floatY&floatZ QuaternionToEuler( Quaternion, bool LOG )
    /* Converts a quaternion to Euler angles (in degrees).

       LOG - if true, prints the resulting Euler angles
             to the game log.

       Returns:
           X
           Y
           Z */

    [M] Quaternion GetFixedQuaternion( Quaternion )
    /* Returns a corrected quaternion.

       Useful for repairing invalid or mirrored rotations that cause
       objects to face the wrong direction despite otherwise correct
       orientation data. */

    [M] float CVectorDot( CVector 1, CVector 2 )
    /* Returns the dot product of two vectors. */

    [M] CVector CVectorCross( CVector 1, CVector 2 )
    /* Returns the cross product of two vectors. */

    [M] CVector CVectorNormalize( CVector )
    /* Returns the normalized version of the specified vector. */

    [M] int GetMapSize()
    /* Returns the size of the current map in meters. */


    /* Internal Functions. Avoid using these whenever possible. */

    [M] CVector&Object IsCameraLookAt_VectorDrawer_f()
    /* Function alternative to the "IsCameraLookAt_VectorDrawer" trigger.

       Advantages:
           - Raycasting is performed instantly.
       Disadvantages:
           - It's lagging, Ex Machina can't handle it. */

    [M] Quaternion CVectorEulerToQuaternion( float pitch, float yaw, float roll, bool LOG )
    /* Converts Euler angles (in degrees) to a quaternion.

       LOG - if true, prints the resulting quaternion
             to the game log.

       Unlike EulerToQuaternion(), this function expects
       CVector axis order:
           pitch = Y
           yaw   = Z
           roll  = X */

    [M] floatX&floatY&floatZ CVectorQuaternionToEuler( Quaternion, bool LOG )
    /* Converts a quaternion to Euler angles (in degrees).

       LOG - if true, prints the resulting Euler angles
             to the game log.

       Returned axis order matches CVector conventions:
           pitch = Y
           yaw   = Z
           roll  = X */
}
```

<a id="aboutCVectorAndQuaternion_en"></a><a href="#top">Go up ↑</a>

## What are "coordinates"
In the game coordinates are three numeric values that **define a point in space** at the game level and are measured in meters: `x` `y` `z`, where `x` is west/east; `y` is up/down; `z` - north/south. The coordinates are calculated from the lower left edge of the game level (southwest) and depend on its size.

- Type of coordinates: `CVector(1,2,3)` - `1`=` x`, `2`=`y` and `3`=`z`.

## What is "rotation"?
In the game, rotation is a system of a right-directional quaternion containing four numeric values, which **defines rotation in space**: `x` `y` `z` `w`, where `x` is rotation along the `x` axis; `y` is rotation along the `y` axis; `z` - rotation along the `z` axis; `w` - rotation by an angle of θ (theta). The values can be from `-1` to `1`. The quaternion is calculated by the sines and cosines of the halves of the angles in radians using the formulas. *Improved3D allows you to count Euler angles along three axes into quaternion angles and vice versa.*

- Type of rotation: `Quaternion(0,0,0,1)` - zeros for the axes `x` `y` `z` and `1` for rotation θ - north (`0` for rotation θ - south, inversion): **the object is facing FORWARD on the Z axis to the north of the map**.

## What is a "direction"?
In the game, the direction is the coordinate vector `CVector`, which **sets the direction in space**. The values of the axes `x` `y` `z` are added together and a vector with the desired direction and length (force) is obtained. Any physical object in the game contains information about its direction (movement), even if it is standing still. The calculation of directions is necessary for the displacement of points and rotations relative to each other.

- Type of direction: `CVector(0,0,1)` - vector is directed to the north of the map; `CVector(0,1,0)` - vector is directed upward; `CVector(1,0,0)` - vector is directed to the east of the map.

<a id="triggerIsCameraLookAt_en"></a><a href="#top">Go up ↑</a>

## Trigger `IsCameraLookAt_VectorDrawer`
Needed for the function `IsCameraLookAt`

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
            coroutine.resume(I3D.LookAtProcess, pos, entity)
            trigger:Deactivate()
        end
    </script>
</trigger>
```

<a id="howToDoFlyingObject_en"></a>

## How to make a flying object like in a gif

I'll just show you the triggers that I used for this demo, but I'll add comments with explanations:

```xml
<trigger Name="a" active="0">
    <event timeout="1" eventid="GE_TIME_PERIOD" />
	<script>
        --Turning on the camera's flight, I set a point in space where I want to hover the car/object.
        --Ativate the trigger in the console.
        --I record the camera position in a global variable:
        GL_gde = GetCameraPos()

        --Then I create the Urals at this point:
        TeamCreate("aimteam", 1004, GL_gde, Quaternion(0,0,0,1), {"Ural01"})

        --Then I turn on the trigger for "surveillance", and turn off this one:
        TActivate("aim")
        trigger:Deactivate()
    </script>
</trigger>

<trigger Name="aim" active="0">
    <event timeout="0" eventid="GE_TIME_PERIOD" />
    <script>
        --Since I created the Ural, it falls down according to the laws of physics.
        --This is not necessary for static objects...
        --After turning on this trigger, it "catches" the falling object,
        --And assigns it the position in which it was created again.
        --Without any checks, because it's for demonstration:
        getObj("aimteam_vehicle_0"):SetPosition(GL_gde)
		
		--So that the object can move sideways instead of being at the same point,
		--You can apply only certain coordinates to it, for example Y:
		--local gde = getObj("aimteam_vehicle_0"):GetPosition()
		--getObj("aimteam_vehicle_0"):SetPosition(gde.x, GL_gde.y, gde.z)

		--And so that it can fly with a fixed height above the landscape:
		--local gde = getObj("aimteam_vehicle_0"):GetPosition()
		--gde.y = g_ObjCont:GetHeight(gde.x, gde.z) + 11 --desired height in meters!
		--getObj("aimteam_vehicle_0"):SetPosition(gde)

        --After "hanging" the object "by the scruff", I call I3D:SetObjectLookAt,
        --Which prints the rotation of the "gaze" to the console via println, you can also watch this:
        println(I3D:SetObjectLookAt(getObj("aimteam_vehicle_0"), GetPlayerVehicle(), false, true))
        --If you don't know how this function works yet, find it in the "FUNCTIONS AND METHODS" section.
		--You can write other I3D functions to create some other movement.
		--Or move an object by impulses through SetCustomLinearVelocity...

        --Please note that I do not disable this trigger - it works indefinitely!
        --You will need to come up with options to disable it, if necessary...
    </script>
</trigger>
```

<a id="detailsAndThanks_en"></a><a href="#top">Go up ↑</a>

## LEARN MORE

You can find this and other information in the project file or find examples of how the module works in the ExplorerMod mod from the same author.

You can read about game maps in *[tutorial article on DeusWiki](https://deuswiki.com/w/Участник:Axeble)* from the same author.


## AUTHOR'S COMMENTS

    E Jet: Thank you to our chefs for making delicious food for us!

## Gratitude 

- ***crtvxxx*** for your help with `math.`! In the imported function from ExplorerMod to circle spawn, I first encountered a MATH problem! The function may have been completely rewritten, but respect is eternal! This guy helped out with a whole feature!
- ***Rusya_27*** for feedback and bug detection!
- ***Gnome627*** for function `I3D:p()`!
- ***Varisane*** for feedback!

<a href="#top">Go up ↑</a>
