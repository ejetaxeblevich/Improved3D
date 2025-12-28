# ПРОСТРАНСТВЕННЫЙ LUA-МОДУЛЬ

Написанный специально для игры Ex Machina / Hard Truck Apocalypse

### Note: Please translate this text, if it nessesary.

[comment]: <> ( Этот readme не имеет красивого оформления, поэтому используйте поиск по тексту вверху справа.)
[comment]: <> ( <div align="center">)
[comment]: <> ( <img width="114" height="92" alt="image" src="https://github.com/user-attachments/assets/9ed52681-407d-44c1-8a02-6df8c0cbd563" />)
[comment]: <> ( </div>)


## ЧТО ЭТО

Универсальный lua-модуль, который может использоваться для **расширения возможностей** на "манипулирование пространством" в игре.

Вы сможете более **гибко расчитывать координаты и вращение, удобно размещать и вращать объекты**, пользоваться некоторыми техническими возможностями, что не могла сделать сама игра из доступных публичных методов. Я не нашел нужного функционала непосредственно в игре, поэтому пришлось придумать (костылить) что-то свое.


Почему это "модуль", а не любой другой файл с lua-скриптами? Хотя он таким и является...
- Потому что этот файл - таблица функций I3D (далее класс), который имеет свои собственные методы и функции, что очень похоже на серьезную тему. Наверное. Типа. Я хз...


### Дисклеймер

АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК.


АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ НАПИСАННОМ ДИСКЛЕЙМЕРЕ.


LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.

АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.

## [СКАЧАТЬ Improved3D](https://github.com/ejetaxeblevich/Improved3D/blob/main/improved3d.lua)
Перейдя на страницу, нажмите на кнопку **"Download raw file"**.


## КАК ЭТО ИСПОЛЬЗОВАТЬ

Для полноценного lua-модуля этой поделке еще далеко, поэтому ее не нужно устанавливать как библиотеку Lua в системе.

В игру этот lua-модуль загружается двумя способами: через `require()` или `dofile()`. Это внутренние Lua команды игры. 
Наш знакомый `EXECUTE_SCRIPT` не подойдет, так как он не возвращает объект модуля.


Чем отличается `require()` от `dofile()`? 


- `require()` загружает файл в игру при первом выполнении и держит в памяти игры до перезапуска. Эта команда используется для подгрузки модулей здорового человека, которые устанавливаются в систему (но необязательно);
- `dofile()` загружает в память игры файл столько раз, сколько был вызван. Очищается весь внутренний кеш lua-модуля и принимаются настройки по умолчанию. Рекомендуется для отладки и прочего дебага.

Рекомендую прописывать команду в начало файла `server.lua` игры, поскольку могут использоваться в модуле команды, которые грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).


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
    I3D = require("data\\gamedata\\lua_lib\\improved3d.lua")
    if not I3D then
        LOG("[E] Could not find global Improved3D.lua...")
    end
```

## ФУНКЦИИ И МЕТОДЫ

Здесь собраны все публичнные функции этого модуля. У каждой функции имеется детальное описание, что она делает и что в ней указывать. 

**Обратите внимание**, что дочерний класс должен вызывать главный метод своего родительского класса вплоть до `I3D`.

Для настройки работы `IsCameraLookAt` можно и нужно редактировать функцию `IsCameraLookAt_Callback` раздела `USER EDITABLE FUNCTIONS` внутри файла. Стоит также ознакомиться с триггером `IsCameraLookAt_VectorDrawer`.

```c
   Class I3D
   {
      /* Расширенное манипулирование 3D пространством */
      [M] Quaternion SetObjectLookAt( object SetAim, object GetAim, bool OnlyYaw, bool LockRoll )  /* Обращает взор первого объекта на позицию второго объекта - как аим камеры в катсценах. Для плавной работы необходимо вызывать каждый раз: objSetAim = объект, который нужно повернуть; objGetAim = объект или позиция, на которую надо "смотреть": может быть getObj(), CVector(), GetCameraPos(); boolOnlyYaw = применяется вращение только по оси Y (как турель), если true; boolLockRoll = запрещается вращение по оси Z (наклон), если true. Примеры: SetObjectLookAt(getObj("aim_object_name"), GetPlayerVehicle(), false, true) --> Аим на объект; SetObjectLookAt(getObj("aim_object_name"), GetCameraPos(), false, true) --> Аим на камеру */
      [M] void IsCameraLookAt( float DrawVectorQuant, float DrawVectorQuantMultiplier, float DrawVectorMinDistance, float DrawVectorMaxDistance, float DrawCatchZoneSize )        /* Смотрит ли куда-то камера? Бросает луч из камеры и пытается что-то "нащупать" (работает с триггером "IsCameraLookAt_VectorDrawer" или с IsCameraLookAt_VectorDrawer_f()): float DrawVectorQuant = шаг построения отрезка луча (в метрах); float DrawVectorQuantMultiplier = множитель шага построения отрезка луча (1.0); float DrawVectorMinDistance = минимальное расстояние, после которого идет захват объекта лучом (в метрах); float DrawVectorMaxDistance		= максимальное расстояние захвата объектов лучом (в метрах); float DrawCatchZoneSize = размер зоны захвата объектов в точке луча (в метрах); Пример: I3D:IsCameraLookAt(5,1,20,1000,5) */
      [M] ??? IsCameraLookAt_Callback( CVector pos, Object entity )       /* Настраивается пользователем. Эта callback-функция вызывается GetCameraLookAtProcess, когда он завершается. Нужна как обработка ивента окончания работы луча. Аргументы возвращает сам GetCameraLookAtProcess: pos = CVector точки, куда смотрела камера на момент вызова IsCameraLookAt(); entity = Object сущности, какую захватил луч, может быть nil. Доступен такой же контроль, как через GetEntityByName() */
      [M] bool IsInCameraView( CVector pos, float fov_deg, int window_w, int window_h, table region )   /* Находится ли точка в поле зрения камеры с fov и размерами окна игры. Пытается взять window из конфига игры если nil. Может принять границы захвата region на экране пропорционально с left, right, bottom, top (от -1 до 1) */
      [M] CVector RotateAroundPoint( CVector 1, CVector 2, Quaternion or tableRotation )  /* Возвращает  точку повернутого вектора2 вокруг вектора1 на угол tableRotation [{90,0,0}] или Quaternion() */
      [M] CVector LinearMoveAroundPoint( CVector 1_old, CVector 1_new, CVector 2_old )    /* Возвращает точку сдвинутого вектора2 линейно вместе с вектором1: 1_old = последняя сохраненная позиция вектора1; 1_new	= новая позиция вектора1; 2_old	= последняя сохраненная позиция вектора2 */
      [M] CVector AdjustDistanceBetweenVectors( CVector 1_old, CVector 2_old, float target_dist )     /* Возвращает точку вектора2 на нужном расстоянии от вектора1: 1_old = последняя сохраненная позиция вектора1; 2_old = последняя сохраненная позиция вектора2; target_dist = требуемое расстояние между векторами */
      [M] CVector GetEndOfBeam( CVector origin, Quaternion, float distance )      /* Возвращает точку на расстоянии distance от origin, направленную по вращению quaternion */
      [M] CVector&boolObstacle DrawVector( CVector origin, Quaternion, float distance )   /* Рисует вектор в игровом мире длиной distance от origin, направленного по вращению quaternion и возвращает его вторую точку (воспринимает препятствия в виде ландшафта и края карты) */
      [M] Object CallEntityInZone( CVector pos, float ZoneSize, bool GetsIntoCamera )     /* Возвращает объект, что находится в желаемой точке: posVector = CVector точки, позиция камеры если nil; float ZoneSize = размер зоны у точки, в которой может быть объект (в метрах); bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true */
      [M] table GetAllEntities( bool GetsIntoCamera )         /* Возвращает все объекты на карте, что имеют позиции CVector и их количество: bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true */

      /* Помощь в расчетах */
      [M] CVector ParseCVector( string CVector )      /* Возвращает CVector из строки с CVector (юзердату) */
      [M] Quaternion EulerToQuaternion( float x, float y, float z, bool LOG ) /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. */
      [M] EulerX&EulerY&EulerZ QuaternionToEuler( Quaternion, bool LOG )      /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. */
      [M] Quaternion GetFixedQuaternion( Quaternion )         /* Возвращает исправленное вращение. Как понять, что ваше вращение понос спидозного бомжа? - объект хуй пойми куда смотрит, а не куда ему нужно */
      [M] Quaternion QuaternionFromTo( CVector From, CVector To )     /* Возвращает кватернион от вектора к вектору (вращение из одного направления в другое) */
      [M] CVector RotateCVectorByQuaternion( CVector, Quaternion )    /* Возвращает точку помноженного вектора на кватернион (поворот CVector по вращению Quaternion) */
      [M] CVectorX&CVectorY&CVectorZ QuaternionToAxes( Quaternion )   /* Возвращает направления по осям из кватерниона */
      [M] CVector CVectorAverage( table CVectors, bool Y )    /* Возвращает точку как среднее арифметическое векторов, считает Y если true */
      [M] CVector GetForwardFromQuaternion( Quaternion )      /* Возвращает направление "вперед" из вращения */
      [M] float CVectorDot( CVector 1, CVector 2 )            /* Возвращает скалярное произведение двух векторов */
      [M] CVector CVectorCross( CVector 1, CVector 2 )        /* Возвращает точку векторного произведения двух векторов */
      [M] CVector CVectorNormalize( CVector )         /* Возвращает нормализацию вектора */
      [M] int GetMapKilometers()       /* Возвращает константу размера текущей карты в километрах */

      /* Сервисные функции. По возможности не используйте */
      [M] CVector&Object IsCameraLookAt_VectorDrawer_f()      /* Функция вместо триггера "IsCameraLookAt_VectorDrawer". Плюсы: Луч строится мгновенно; Минусы: Экс Машина */
      [M] Quaternion CVectorEulerToQuaternion( float pitch, float yaw, float roll, bool LOG )     /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. Используйте на входе: pitch = y, yaw = z, roll = x */
      [M] EulerX&EulerY&EulerZ CVectorQuaternionToEuler( Quaternion, bool LOG )   /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. Используйте на выходе pitch = y, yaw = z, roll = x. */
   }
```


### Триггер `IsCameraLookAt_VectorDrawer`

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


## КОММЕНТАРИИ АВТОРА

    E Jet: Спасибо нашим поварам за то, что вкусно варят нам!
