-- ============================================================
-- ============================================================
-- 
-- 
--                ПРОСТРАНСТВЕННЫЙ LUA-МОДУЛЬ,
-- 
--               написанный специально для игры
--             Ex Machina / Hard Truck Apocalypse
--
--                     Improved3D v1.1
-- 
-- 
-- ====================== Автор E Jet =========================
-- ============================================================
-- 
--     Note: Please translate this text, if it nessesary.
-- 
-- 
-- ======================= ЧТО ЭТО ============================
-- 
-- 
--      Универсальный lua-модуль, который может использоваться
-- для расширения возможностей на "манипулирование пространством"
-- в игре.
--      Вы сможете более гибко расчитывать координаты и вращение,
-- удобно РАЗМЕЩАТЬ и ВРАЩАТЬ объекты, пользоваться некоторыми 
-- техническими возможностями через скрипты любой модификации 
-- внутри игры, что не могла сделать сама игра из доступных 
-- публичных методов.
--      Я не нашел нужного функционала непосредственно в игре,
-- поэтому пришлось придумать (костылить) что-то свое.
-- 
--      Почему это "модуль", а не любой другой файл с lua-скриптами?
-- Хотя он таким и является...
--      Потому что этот файл - таблица функций I3D (далее класс), 
-- который имеет свои собственные методы и функции, что очень 
-- похоже на серьезную тему. Наверное. Типа. Я хз...
--
------------------------- Дисклеймер -----------------------
--
--      АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО
-- НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ 
-- ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И 
-- ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК. 
--      АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ
-- ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ
-- ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ 
-- НАПИСАННОМ ДИСКЛЕЙМЕРЕ.
--
--      LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И 
-- ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE И МОЖЕТ 
-- БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ 
-- МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.
--      АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, 
-- ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А
-- ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ
-- ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.
-- 
---------------------------------------------------------------
--
-- ================= КАК ЭТО ИСПОЛЬЗОВАТЬ =====================
-- 
-- 
--      Для полноценного lua-модуля этой поделке еще далеко, 
-- поэтому ее не нужно устанавливать как lua-библиотеку в системе.
-- 
--      В игру этот lua-модуль загружается двумя способами: через 
-- [require()] или [dofile()]. Это внутренние lua-команды игры. 
-- Наш знакомый [EXECUTE_SCRIPT] не подойдет, так как он не возвращает 
-- объект модуля.
--      Чем отличается [require()] от [dofile()]? 
--      - [require()] загружает файл в игру при первом выполнении
-- и держит в памяти игры до перезапуска. Эта команда используется 
-- для подгрузки модулей здорового человека, которые устанавливаются 
-- в систему (но необязательно);
--      - [dofile()] загружает в память игры файл столько раз, 
-- сколько был вызван. Очищается весь внутренний кеш lua-модуля и
-- принимаются настройки по умолчанию. Рекомендуется для отладки и
-- прочего дебага.
--      Рекомендую прописывать команду в начало файла server.lua
-- игры, поскольку могут использоваться в модуле команды, которые 
-- грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).
--
--      В качестве аргумента функции указывается локальный путь до 
-- файла модуля.
--      Возвращаемая таблица помещается в глобальную переменную, 
-- которая будет использована как объект, на который будут 
-- применяться методы (функции) этого модуля через двоеточие. 
--
-- Чтобы было понятнее, вспомним как мы обращаемся к машине игрока:
-- 
-- lua
-- [[
--      local Plv = GetPlayerVehicle()
--      if Plv then
--          Plv:SetSkin(1)  --> метод на объект
--      end
-- ]]
--
-- Или к обжект контейнеру:
--
-- lua
-- [[
--      local Gde = CVector(1,2,3)
--      local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> метод на объект
-- ]]
-- 
--      После загрузки модуля в игру уже можно начинать пользоваться его
-- командами.
--
-----------------------------------------------------------------
--
----------------- \/ Пример кода загрузки \/ --------------------
--
-- lua
-- [[
--     I3D = require("data\\gamedata\\lua_lib\\improved3d.lua")
--     if not I3D then
--         LOG("[E] Could not find global Improved3D.lua...")
--     end
-- ]]
--
---------------------------------------------------------------
--
-- ================= ТЕХНИКА БЕЗОПАСНОСТИ =====================
--
--      ЗАПРЕЩАЕТСЯ использовать этот lua-модуль в своих модах
-- без указания авторства.
--      А то натравлю порчу и наколдую недельный понос >:(
--      Шутка :*
--
---------------------------------------------------------------
--
-- =================== ФУНКЦИИ И МЕТОДЫ =======================
--
--
--      Здесь собраны все публичнные функции этого модуля. У 
-- каждой функции имеется детальное описание, что она делает и
-- что в ней указывать. 
--
--      Для настройки работы [IsCameraLookAt] можно и нужно 
-- редактировать функцию [IsCameraLookAt_Callback] раздела 
-- USER EDITABLE FUNCTIONS ниже. Стоит также ознакомиться с
-- триггером "IsCameraLookAt_VectorDrawer".
--
---------------------------------------------------------------
--
-- c
-- [[
--    Class I3D
--    {
--       /* Расширенное манипулирование 3D пространством */
--       [M] table Positions SetObjectsAroundCircle( table ListOfObjects, CVector CenterPos, Quaternion BaseRotation, float Radius, float StartAngleDeg, bool or Quaternion LookOutside, bool AutoRadius, bool PosAbsolute )    /* Размещает выбранные объекты ListOfObjects по окружности в позиции CenterPos и вращением орбиты BaseRotation с начальным радиусом Radius, с углом смещения первого объекта по орбите на StartAngleDeg. Объекты смотрят наружу, если LookOutside = true, иначе внутрь, можно передать Quaternion для своего вращения. Объекты размещаются с динамическим радиусом, зависящим от длины конкретного объекта, если AutoRadius = true, иначе выравнивание по длине первого объекта в списке (чтобы не спавнились друг в друге). Размещает объекты с фиксированной высотой, если PosAbsolute = true, иначе на ландшафте */
--       [M] Quaternion SetObjectLookAt( object SetAim, object GetAim, bool OnlyYaw, bool LockRoll )    /* Обращает взор первого объекта на позицию второго объекта - как аим камеры в катсценах. Для плавной работы необходимо вызывать каждый раз: objSetAim = объект, который нужно повернуть; objGetAim = объект или позиция, на которую надо "смотреть": может быть getObj(), CVector(), GetCameraPos(); boolOnlyYaw = применяется вращение только по оси Y (как турель), если true; boolLockRoll = запрещается вращение по оси Z (наклон), если true. Примеры: SetObjectLookAt(getObj("aim_object_name"), GetPlayerVehicle(), false, true) --> Аим на объект; SetObjectLookAt(getObj("aim_object_name"), GetCameraPos(), false, true) --> Аим на камеру */
--       [M] void IsCameraLookAt( float DrawVectorQuant, float DrawVectorQuantMultiplier, float DrawVectorMinDistance, float DrawVectorMaxDistance, float DrawCatchZoneSize )        /* Смотрит ли куда-то камера? Бросает луч из камеры и пытается что-то "нащупать" (работает с триггером "IsCameraLookAt_VectorDrawer" или с IsCameraLookAt_VectorDrawer_f()): float DrawVectorQuant = шаг построения отрезка луча (в метрах); float DrawVectorQuantMultiplier = множитель шага построения отрезка луча (1.0); float DrawVectorMinDistance = минимальное расстояние, после которого идет захват объекта лучом (в метрах); float DrawVectorMaxDistance = максимальное расстояние захвата объектов лучом (в метрах); float DrawCatchZoneSize = размер зоны захвата объектов в точке луча (в метрах); Оригинальный lookAt у [GetCameraPos()] сломан. Пример использования: I3D:IsCameraLookAt(5,1,20,1000,5) */
--       [M] ??? IsCameraLookAt_Callback( CVector pos, Object entity )     /* Настраивается пользователем. Эта callback-функция вызывается GetCameraLookAtProcess, когда он завершается. Нужна как обработка ивента окончания работы луча. Аргументы возвращает сам GetCameraLookAtProcess: pos = CVector точки, куда смотрела камера на момент вызова IsCameraLookAt(); entity = Object сущности, какую захватил луч, может быть nil. Доступен такой же контроль, как через GetEntityByName() */
--       [M] bool IsInCameraView( CVector pos, table region )              /* Находится ли точка в поле зрения камеры. Границы захвата на экране region={} пропорционально с left, right, bottom, top (от -1 до 1) */
--       [M] bool IsInCameraViewSquared( CVector pos, float ScopeCoeff )   /* Находится ли точка в поле зрения камеры. Границы захвата на экране в квадратном соотношении с ScopeCoeff (от -1 до 1) */
--       [M] bool IsObjectInCameraView( object Entity, float ScopeCoeff, bool SquareScope )   /* Находится ли объект в поле зрения камеры. Объединяет между собой [IsInCameraViewSquared] и [IsInCameraView], где: Entity - объект как getObj() или GetEntityByName(); ScopeCoeff - коэффициент размера зоны захвата на экране (от 0 до 1, где 1 = весь экран). Может быть как region={} с left, right, top, bottom (от -1 до 1); SquareScope - квадратное соотношение зоны захвата, если true */
--       [M] CVector RotateAroundPoint( CVector 1, CVector 2, Quaternion or tableRotation )   /* Возвращает точку повернутого вектора2 вокруг вектора1 на угол tableRotation [{90,0,0}] или Quaternion() */
--       [M] CVector LinearMoveAroundPoint( CVector 1_old, CVector 1_new, CVector 2_old )     /* Возвращает точку сдвинутого вектора2 линейно вместе с вектором1: 1_old = последняя сохраненная позиция вектора1; 1_new	= новая позиция вектора1; 2_old	= последняя сохраненная позиция вектора2 */
--       [M] CVector AdjustDistanceBetweenVectors( CVector 1_old, CVector 2_old, float target_dist )     /* Возвращает точку вектора2 на нужном расстоянии от вектора1: 1_old = последняя сохраненная позиция вектора1; 2_old = последняя сохраненная позиция вектора2; target_dist = требуемое расстояние между векторами */
--       [M] CVector GetEndOfBeam( CVector origin, Quaternion, float distance )      /* Возвращает точку на расстоянии distance от origin, направленную по вращению quaternion */
--       [M] CVector&boolObstacle DrawVector( CVector origin, Quaternion, float distance )    /* Рисует вектор в игровом мире длиной distance от origin, направленного по вращению quaternion и возвращает его вторую точку (воспринимает препятствия в виде ландшафта и края карты) */
--       [M] Quaternion QuaternionFromTo( CVector From, CVector To )           /* Возвращает кватернион от вектора к вектору (вращение из одного направления в другое) */
--       [M] Quaternion QuaternionByLandscape( CVector vec, Quaternion rot )   /* Возвращает кватернион по уровню ландшафта. Выравнивает объект по ландшафту, чтобы он не был строго в горизонте при появлении */
--       [M] CVector RotateCVectorByQuaternion( CVector, Quaternion )    /* Возвращает точку помноженного вектора на кватернион (поворот CVector по вращению Quaternion) */
--       [M] CVectorX&CVectorY&CVectorZ QuaternionToAxes( Quaternion )   /* Возвращает направления по осям из кватерниона */
--       [M] Quaternion QuaternionFromAxes( CVector right, CVector up, CVector forward )  /* Возвращает кватернион из направлений по осям */
--       [M] CVector GetForwardFromQuaternion( Quaternion )      /* Возвращает направление "вперед" из вращения */
--       [M] CVector CVectorAverage( table Positions, bool Y )   /* Возвращает точку как среднее арифметическое векторов, считает Y если true */
--       [M] Object CallEntityInZone( CVector pos, float ZoneSize, bool GetsIntoCamera )     /* Возвращает объект, что находится в желаемой точке: posVector = CVector точки, позиция камеры если nil; float ZoneSize = размер зоны у точки, в которой может быть объект (в метрах); bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true */
--       [M] table GetAllEntities( bool GetsIntoCamera )         /* Возвращает все объекты на карте, что имеют позиции CVector и их количество: bool GetsIntoCamera = захватывает только объекты в поле зрения камеры, если true */
--
--       /* Помощь в расчетах */
--       [M] bool IsCVector( userdata )      /* Проверяет значение юзердаты, что это координаты CVector */
--       [M] bool IsQuaternion( userdata )   /* Проверяет значение юзердаты, что это вращение Quaternion */
--       [M] string IsUserdata( userdata )   /* Проверяет значение юзердаты. Объединяет [IsCVector()] и [IsQuaternion()], возвращая строковые значения для сравнения: ["cvector"], ["quaternion"], ["userdata"], ["not userdata"]. Бонусом может вернуть строкой класс объекта */
--       [M] table UpdateScreenInfo()        /* Обновляет переменные модуля и возвращает fov, width и height окна игры */
--       [M] CVector GetCameraPos()      /* Обертка стандартного [GetCameraPos()] под координаты */
--       [M] Quaternion GetCameraRot()   /* Возвращает исправленное вращение камеры от [GetCameraPos()]. Оригинальное вращение зеркально от полюсов, которое нормально работает для камеры в катсценах, но не для объектов */
--       [M] CVector ParseCVector( string CVector )     /* Возвращает CVector из строки с CVector (юзердату) */
--       [M] table Positions ItemsToCVectors( table Items )       /* Преобразует список из разных элементов в список с их CVector (юзердаты). Элементами могут быть: ["MyVehicleName"], [getObj()], ["1 2 3"], [CVector(1,2,3)] */
--       [M] table Objects CollectVehiclesByTeam( string TeamName )   /* Возвращает список найденных машин из команды по имени TeamName */
--       [M] table Objects CollectObjects( table ObjectNamesOrIDs )   /* Возвращает список найденных объектов из списка. Могут быть имена и айди */
--       [M] Quaternion EulerToQuaternion( float x, float y, float z, bool LOG )   /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. */
--       [M] floatX&floatY&floatZ QuaternionToEuler( Quaternion, bool LOG )        /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. */
--       [M] Quaternion GetFixedQuaternion( Quaternion )     /* Возвращает исправленное вращение. Как понять, что ваше вращение понос спидозного бомжа? - объект хуй пойми куда смотрит, а не куда ему нужно */
--       [M] float CVectorDot( CVector 1, CVector 2 )        /* Возвращает скалярное произведение двух векторов */
--       [M] CVector CVectorCross( CVector 1, CVector 2 )    /* Возвращает точку векторного произведения двух векторов */
--       [M] CVector CVectorNormalize( CVector )       /* Возвращает нормализацию вектора */
--       [M] int GetMapSize()     /* Возвращает константу размера текущей карты в метрах */
--
--       /* Сервисные функции. По возможности не используйте */
--       [M] CVector&Object IsCameraLookAt_VectorDrawer_f()      /* Функция вместо триггера "IsCameraLookAt_VectorDrawer". Плюсы: Луч строится мгновенно; Минусы: Экс Машина */
--       [M] Quaternion CVectorEulerToQuaternion( float pitch, float yaw, float roll, bool LOG )     /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. Используйте на входе: pitch = y, yaw = z, roll = x */
--       [M] floatX&floatY&floatZ CVectorQuaternionToEuler( Quaternion, bool LOG )   /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. Используйте на выходе pitch = y, yaw = z, roll = x. */
--    }
-- ]]
--
---------------------------------------------------------------
--
------------- Триггер "IsCameraLookAt_VectorDrawer" -----------
--
-- xml
-- [[
--     <trigger Name="IsCameraLookAt_VectorDrawer" active="0">
--         <event timeout="0.001" eventid="GE_TIME_PERIOD" />
--         <script>
--             trigger:IncCount()
--             local skoka = trigger:GetCount()
--             local pos, obstacle = I3D:DrawVector(I3D.LookAtCVector, I3D.LookAtQuaternion, I3D.LookAtDistance)
--             I3D.LookAtDistance = I3D.LookAtDistance * I3D.LookAtDistanceCoeff
--             I3D.LookAtCVector = pos
--             local entity = nil
--             if (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMin) then
--                 entity = I3D:CallEntityInZone(pos, I3D.LookAtZoneSize)
--             end
--             if obstacle or entity or (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMax) then
--                 coroutine.resume(_G["GetCameraLookAtProcess"], pos, entity)
--                 trigger:Deactivate()
--             end
--         </script>
--     </trigger>
-- ]]
--
---------------------------------------------------------------
--
-- ======================= ПОДРОБНЕЕ ==========================
--
--
--      Эту и другую информацию вы сможете найти на github  
-- проекта или найти примеры работы модуля в моде ExplorerMod 
-- от того же автора.
--      Ссылка на github: https://github.com/ejetaxeblevich
--
---------------------------------------------------------------
--
-- =================== КОММЕНТАРИИ АВТОРА =====================
-- 
-- E Jet: Спасибо нашим поварам за то, что вкусно варят нам!
-- 
-- E Jet: Благодарность crtvxxx за помощь с math.!
--      В импортированной функции из ExplorerMod на спавн по 
-- окружности я впервые столкнулся с проблемой МАТЕМАТИКИ! Пусть
-- функция и была переписана полностью, но уважение вечно! Этот
-- парень выручил целую фичу!
--
-- ============================================================
-- ============================================================



-- //////////////////////////// MODULE INIT /////////////////////////////////


local I3D = {}
I3D.__index = I3D
I3D.version = "v1.1"

LOG("[I] Init Module Improved3D.lua ...")


-- ////////////////////////// DEFAULT MODULE CONSTANTS //////////////////////////


I3D.Default_FOV = 70
I3D.Default_Width = 1920
I3D.Default_Height = 1080


if not g_ObjCont then
    LOG("[E] Module Improved3D.lua === g_ObjCont not found!!!")
    return
end


-- ///////////////////////////////////////////////////////////////////////////////

-- ////////////////////////// USER EDITABLE FUNCTIONS ////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////


function I3D:IsCameraLookAt_Callback(pos, entity)
	if not pos then
		return
	end

	--эффект для демонстрации точки, куда смотрит камера
	CreateNewSgNodeObject("ET_PS_LENS_D1", "IsCameraLookAtEffect", -1, -1, pos, Quaternion(0,0,0,1), 2)
	
	--пытаемся взаимодействовать с сущностью, захваченой лучом
	local class = "nothing"
	if entity then
		class = entity:GetClassName()
	end

	--принт в консоль
	println("you look at: "..class.." for position: "..tostring(pos))
end


-- ///////////////////////////////////////////////////////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////



-- ///////////////////////////// LOCAL FUNCTIONS ////////////////////////////


local function get_config(stringParamName)
	local value
	local f = io.open("data\\config.cfg", "r")
	if f then
		local data = f:read("*all")
		f:close()
		_,_, value = string.find(data, stringParamName..'%s*=%s*"([^"]*)"')
	end
	return value
end

local function get_screen()
    local fov_deg = tonumber(get_config("fov")) or I3D.Default_FOV
	local window_w = tonumber(get_config("r_width")) or I3D.Default_Width
	local window_h = tonumber(get_config("r_height")) or I3D.Default_Height
    return fov_deg, window_w, window_h
end

local function get_commas(value)
    local s = tostring(value)
    local _, commas = string.gsub(s, ",", ",")
    return commas or 0
end


-- ///////////////////////////////////////////////////////////////////////////////

-- //////////////////////// GLOBAL MODULE FUNCTIONS //////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////


function I3D:IsCVector(userdata)
    if type(userdata)=="userdata" then
        if get_commas(userdata)==2 then
            return true
        end
    end
    return false
end

function I3D:IsQuaternion(userdata)
    if type(userdata)=="userdata" then
        if get_commas(userdata)==3 then
            return true
        end
    end
    return false
end

function I3D:IsUserdata(userdata)
    if type(userdata)=="userdata" or type(userdata)=="table" then
        if I3D:IsCVector(userdata) then
            return "cvector"
        end
        if I3D:IsQuaternion(userdata) then
            return "quaternion"
        end
        local _, class = pcall(function() return userdata:GetClassName() end)
        if class then
            return class
        end
        if type(userdata)=="userdata" then
            return "userdata"
        end
    end
    return "not userdata"
end

function I3D:UpdateScreenInfo()
    local fov_deg, window_w, window_h = get_screen()
    I3D.FOV = fov_deg
    I3D.WINDOW_W = window_w
    I3D.WINDOW_H = window_h
    local info = {
        fov = fov_deg, 
        width = window_w, 
        height = window_h
    }
    return info
end
I3D:UpdateScreenInfo()

function I3D:SetObjectLookAt(objSetAim, objGetAim, boolOnlyYaw, boolLockRoll)
	if not objSetAim then
        LOG("[E] Module Improved3D.lua === SetObjectLookAt(): Error objSetAim")
		return
	end

	local sourcePos = objSetAim:GetPosition()
	local targetPos

	if type(objGetAim)=="userdata" then
		targetPos = objGetAim
	elseif type(objGetAim)=="table" then
		targetPos = objGetAim:GetPosition()
	else
        LOG("[E] Module Improved3D.lua === SetObjectLookAt(): Error objGetAim")
		return
	end

	local direction = I3D:CVectorNormalize(targetPos - sourcePos)

	local baseForward = CVector(0,0,1)
	local lookRotation = I3D:QuaternionFromTo(baseForward, direction)

	if boolLockRoll then
        local x, y, z = I3D:CVectorQuaternionToEuler(lookRotation)
        lookRotation = I3D:CVectorEulerToQuaternion(y, 0, x)
    end
    if boolOnlyYaw then
		local x, y, z = I3D:CVectorQuaternionToEuler(lookRotation)
        lookRotation = I3D:CVectorEulerToQuaternion(y, 0, 0)
    end

	objSetAim:SetRotation(lookRotation)

	return lookRotation
end

function I3D:GetCameraPos()
    return GetCameraPos()
end

function I3D:GetCameraRot()
    local _, rot = GetCameraPos()
    return I3D:GetFixedQuaternion(rot)
end

function I3D:IsCameraLookAt(floatDrawVectorQuant, floatDrawVectorQuantMultiplier, floatDrawVectorMinDistance, floatDrawVectorMaxDistance, floatDrawCatchZoneSize)
    I3D.LookAtCVector = I3D:GetCameraPos()
    I3D.LookAtQuaternion = I3D:GetCameraRot()
	I3D.LookAtStartCVector = I3D.LookAtCVector
	I3D.LookAtDistance = floatDrawVectorQuant or 5
	I3D.LookAtZoneSize = floatDrawCatchZoneSize or 5
	I3D.LookAtDistanceCoeff = floatDrawVectorQuantMultiplier or 1.000
	I3D.LookAtDistanceMin = floatDrawVectorMinDistance or 0
	I3D.LookAtDistanceMax = floatDrawVectorMaxDistance or I3D:GetMapSize()
	
	--сброс эффекта для демонстрации точки, куда смотрит камера
	local LookAtEffect = getObj("IsCameraLookAtEffect")
	if LookAtEffect then LookAtEffect:Remove() end

	TDeactivate("IsCameraLookAt_VectorDrawer")

	_G["GetCameraLookAtProcess"] = coroutine.create(function()
		I3D:GetAllEntities(true)
        local pos, entity
        local trigger = getObj("IsCameraLookAt_VectorDrawer")
        if not trigger then
            pos, entity = I3D:IsCameraLookAt_VectorDrawer_f() --вариант без триггера = луч строится мгновенно, но оч лагает
        else
            trigger:Activate()
            pos, entity = coroutine.yield()
		    GLOBAL_ENTITIES_ON_MAP = nil
            trigger:Deactivate()
        end
        I3D:IsCameraLookAt_Callback(pos, entity)
    end)
	coroutine.resume(_G["GetCameraLookAtProcess"])
end
function I3D:IsCameraLookAt_VectorDrawer_f()
	local skoka = 0
	local pos, obstacle, entity
	repeat
		skoka = skoka + 1
		pos, obstacle = I3D:DrawVector(I3D.LookAtCVector, I3D.LookAtQuaternion, I3D.LookAtDistance)
		I3D.LookAtDistance = I3D.LookAtDistance * I3D.LookAtDistanceCoeff
		I3D.LookAtCVector = pos
		if (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMin) then
			entity = I3D:CallEntityInZone(pos, I3D.LookAtZoneSize)
		end
		if obstacle or entity or (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMax) then
			break
		end
	until obstacle or entity or (skoka * I3D.LookAtDistance>=I3D.LookAtDistanceMax)
	
	return pos, entity
end

function I3D:CollectVehiclesByTeam(stringTeamName)
    local vehicles = {}
    local team = getObj(stringTeamName)
    if not team then
        return
    end
    for i=0, team:GetNumVehicles() or 1 do
        local veh = GetEntityByName(stringTeamName.."_vehicle_"..i)
        if veh then
            --LOG(stringTeamName.."_vehicle_"..i)
            table.insert(vehicles, veh)
        end
    end
    return vehicles
end

function I3D:CollectObjects(tableObjectNamesOrIDs)
    local objects = {}
    for i, name in ipairs(tableObjectNamesOrIDs) do
        local obj = getObj(name)
        if obj then
            table.insert(objects, obj)
        end
    end
    return objects
end

function I3D:SetObjectsAroundCircle(ListOfObjects, CenterPos, BaseRotation, Radius, StartAngleDeg, LookOutside, boolAutoRadius, boolPosAbsolute)
    --спасибо crtvxxx за помощь с math.
    --функция была переписана полностью, но уважение вечно!
    Radius = Radius or 1
    StartAngleDeg = StartAngleDeg or 0
    BaseRotation = BaseRotation or Quaternion(0,0,0,1)

    local count = getn(ListOfObjects)
    if 1 >= count then
        return { CenterPos }, false
    end

    local angleStep = 360 / count
    local Positions = {}

    local up = I3D:RotateCVectorByQuaternion(CVector(0,1,0), BaseRotation)

    local objRadius = Radius
    for i, object in ipairs(ListOfObjects) do
        --авто радиус
        if boolAutoRadius or i==1 then
            objRadius = Radius
            local _, size = pcall(function() return object:GetSize() end)
            objRadius = objRadius + (size and size.z or 0) * 0.75
        end

        local angle = StartAngleDeg + (i-1) * angleStep
        local rad = math.rad(angle)

        --орбита
        local localOffset = CVector(
            math.sin(rad) * objRadius,
            0,
            math.cos(rad) * objRadius
        )
        local worldOffset = I3D:RotateCVectorByQuaternion(localOffset, BaseRotation)
        local pos = CVector(
            CenterPos.x + worldOffset.x,
            CenterPos.y + worldOffset.y,
            CenterPos.z + worldOffset.z
        )

        --направление
        local forward
        if LookOutside and I3D:IsQuaternion(LookOutside) then
            forward = I3D:RotateCVectorByQuaternion(worldOffset, LookOutside)
        elseif LookOutside then
            forward = worldOffset
        else
            forward = CVector(-worldOffset.x, -worldOffset.y, -worldOffset.z)
        end
        forward = I3D:CVectorNormalize(forward)

        local right = I3D:CVectorNormalize(I3D:CVectorCross(up, forward))
        local realUp = I3D:CVectorCross(forward, right)

        local finalRot = I3D:QuaternionFromAxes(right, realUp, forward)

        --назначение
        pcall(function() object:setGodMode(1) end)
        object:SetRotation(finalRot)
        if boolPosAbsolute then
            object:SetPosition(pos)
        else
            local veh = pcall(function() object:SetGamePositionOnGround(pos) end)
            if not veh then
                object:SetPosition(CVector(pos.x, g_ObjCont:GetHeight(pos.x, pos.z), pos.z))
            end
        end
        pcall(function() object:setGodMode(0) end)

        table.insert(Positions, pos)
    end

    return Positions, true
end

function I3D:CVectorDot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

function I3D:CVectorCross(v1, v2)
    return CVector(
        v1.y * v2.z - v1.z * v2.y,
        v1.z * v2.x - v1.x * v2.z,
        v1.x * v2.y - v1.y * v2.x
    )
end

function I3D:CVectorAverage(listVectors, boolY)
	local AverageCVector = CVector(0,0,0)
	local MyCVectors = listCVectorPozs or {CVector(1,0,0), CVector(0,1,0), CVector(0,0,1)}
	local Skoka = getn(MyCVectors)

	local n = 1
	local SummaX = 0
	local SummaY = 0
	local SummaZ = 0
	while MyCVectors[n] do
		SummaX = SummaX + MyCVectors[n].x
		SummaY = SummaY + MyCVectors[n].y
		SummaZ = SummaZ + MyCVectors[n].z
		n=n+1
	end

	if SummaZ>0 and SummaY>0 and SummaX>0 then
		AverageCVector.x = SummaX / Skoka
		AverageCVector.z = SummaZ / Skoka
		if boolY==true then
			AverageCVector.y = SummaY / Skoka
		else
			AverageCVector.y = g_ObjCont:GetHeight(AverageCVector.x, AverageCVector.z)
		end
	end

	return AverageCVector
end

function I3D:ItemsToCVectors(tableItems)
    local vectors = {}
    for i, v in ipairs(tableItems or {}) do
        if type(v)=="userdata" then
            vectors[i] = v
        elseif type(v)=="string" then
            local o = getObj(v)
            if o then
                local _, v = pcall(function() return o:GetPosition() end)
                vectors[i] = v
            else
                vectors[i] = I3D:ParseCVector(v)
            end
        elseif type(v)=="table" then
            local _, v = pcall(function() return v:GetPosition() end)
            vectors[i] = v
        end
    end
    return vectors
end

function I3D:CVectorNormalize(vec)
	--local len = math.sqrt(vec.x^2 + vec.y^2 + vec.z^2)
    local len = vec:length()
	if len == 0 then return vec end
	return CVector(vec.x / len, vec.y / len, vec.z / len)
end

function I3D:QuaternionFromTo(fromVec, toVec)
	fromVec = I3D:CVectorNormalize(fromVec)
	toVec = I3D:CVectorNormalize(toVec)

	local dot = I3D:CVectorDot(fromVec, toVec)

    if dot > 0.9999 then
        --почти совпадают, возвращаем идентичный поворот
        return Quaternion(0,0,0,1)
    end

    if dot < -0.9999 then
        --почти противоположны, поворот на 180 вокруг любой оси, ортогональной fromVec
        --выбираем ось
        local axis = I3D:CVectorCross(CVector(0,1,0), fromVec)
        if (axis.x*axis.x + axis.y*axis.y + axis.z*axis.z) < 0.0001 then
            --up в этом случае близок к fromVec, используем другую ось
            axis = I3D:CVectorCross(CVector(1,0,0), fromVec)
        end
        axis = I3D:CVectorNormalize(axis)
        --quaternion для 180: w=0, xyz=axis
        return Quaternion(axis.x, axis.y, axis.z, 0)
    end

    --общий случай
    local axis = I3D:CVectorCross(fromVec, toVec)
    local s = math.sqrt((1 + dot) * 2)
    local invs = 1 / s

	return Quaternion(
		axis.x * invs,
		axis.y * invs,
		axis.z * invs,
		s * 0.5
	)
end

function I3D:QuaternionByLandscape(vec, rot)
    local tochka1 = vec
    tochka1.y = g_ObjCont:GetHeight(tochka1.x, tochka1.z)

    local tochka2 = I3D:GetEndOfBeam(tochka1, rot, 1)
    tochka2.y = g_ObjCont:GetHeight(tochka2.x, tochka2.z)

    local direction = I3D:CVectorNormalize(tochka2 - tochka1)
    local lookRotation = I3D:QuaternionFromTo(CVector(0,0,1), direction)

    local x, y, z = I3D:CVectorQuaternionToEuler(lookRotation)
    lookRotation = I3D:CVectorEulerToQuaternion(y, 0, x)

    return lookRotation
end

function I3D:RotateCVectorByQuaternion(vec, quat)
    --кватернион-векторное умножение: v' = q * v * q^-1
    local qx, qy, qz, qw = quat.x, quat.y, quat.z, quat.w

    --кватернион-вектор (x, y, z, 0)
    local vx, vy, vz = vec.x, vec.y, vec.z

    --кватернион произведение: q * v
    local ix =  qw * vx + qy * vz - qz * vy
    local iy =  qw * vy + qz * vx - qx * vz
    local iz =  qw * vz + qx * vy - qy * vx
    local iw = -qx * vx - qy * vy - qz * vz

    --кватернион произведение: (q * v) * q^-1
    return CVector(
        ix * qw + iw * -qx + iy * -qz - iz * -qy,
        iy * qw + iw * -qy + iz * -qx - ix * -qz,
        iz * qw + iw * -qz + ix * -qy - iy * -qx
    )
end

function I3D:QuaternionToAxes(q)
    local x, y, z, w = q.x, q.y, q.z, q.w
    local xx, yy, zz = x*x, y*y, z*z
    local xy, xz, yz = x*y, x*z, y*z
    local wx, wy, wz = w*x, w*y, w*z

    local right = CVector(
        1 - 2*(yy + zz),
        2*(xy + wz),
        2*(xz - wy)
    )

    local up = CVector(
        2*(xy - wz),
        1 - 2*(xx + zz),
        2*(yz + wx)
    )

    local forward = CVector(
        2*(xz + wy),
        2*(yz - wx),
        1 - 2*(xx + yy)
    )

    return right, up, forward
end

function I3D:QuaternionFromAxes(right, up, forward)
    local m00, m01, m02 = right.x, up.x, forward.x
    local m10, m11, m12 = right.y, up.y, forward.y
    local m20, m21, m22 = right.z, up.z, forward.z

    local trace = m00 + m11 + m22
    local q = Quaternion(0,0,0,1)

    if trace > 0 then
        local s = math.sqrt(trace + 1.0) * 2
        q.w = 0.25 * s
        q.x = (m21 - m12) / s
        q.y = (m02 - m20) / s
        q.z = (m10 - m01) / s
    elseif m00 > m11 and m00 > m22 then
        local s = math.sqrt(1.0 + m00 - m11 - m22) * 2
        q.w = (m21 - m12) / s
        q.x = 0.25 * s
        q.y = (m01 + m10) / s
        q.z = (m02 + m20) / s
    elseif m11 > m22 then
        local s = math.sqrt(1.0 + m11 - m00 - m22) * 2
        q.w = (m02 - m20) / s
        q.x = (m01 + m10) / s
        q.y = 0.25 * s
        q.z = (m12 + m21) / s
    else
        local s = math.sqrt(1.0 + m22 - m00 - m11) * 2
        q.w = (m10 - m01) / s
        q.x = (m02 + m20) / s
        q.y = (m12 + m21) / s
        q.z = 0.25 * s
    end

    return q
end

function I3D:RotateAroundPoint(v1, v2, rot)
	--смещение векторов
    local diff = CVector(v2.x-v1.x, v2.y-v1.y, v2.z-v1.z)

	--вращение векторов
    local rotatedDiff
    if type(rot)=="userdata" then
        rotatedDiff = I3D:RotateCVectorByQuaternion(diff, rot)
    else
        local quat = I3D:CVectorEulerToQuaternion(rot[2], rot[1], rot[3])
        rotatedDiff = I3D:RotateCVectorByQuaternion(diff, quat)
    end

	--третья точка по окружности
    return CVector(
		v1.x + rotatedDiff.x, 
		v1.y + rotatedDiff.y, 
		v1.z + rotatedDiff.z
	)
end

function I3D:LinearMoveAroundPoint(v1_old, v1_new, v2_old)
    --смещение векторов
    local diff = CVector(v2_old.x-v1_old.x, v2_old.y-v1_old.y, v2_old.z-v1_old.z)

    --новая позиция v2 = новая позиция v1 + то же смещение
    return CVector(
        v1_new.x + diff.x,
        v1_new.y + diff.y,
        v1_new.z + diff.z
    )
end

function I3D:AdjustDistanceBetweenVectors(v1_old, v2_old, target_dist)
    --смещение и расстояние
    local diff = CVector(v2_old.x-v1_old.x, v2_old.y-v1_old.y, v2_old.z-v1_old.z)
    --local current_dist = math.sqrt(diff.x^2 + diff.y^2 + diff.z^2)
    local current_dist = diff:length()
    
    if current_dist == target_dist then
        return v2_old
    end
    
    --нормализация вектора смещения (чтобы он стал единичным)
    local scale = target_dist / current_dist
    
    --второй вектор на расстоянии от первого
    return CVector(
        v1_old.x + diff.x * scale,
        v1_old.y + diff.y * scale,
        v1_old.z + diff.z * scale
    )
end

function I3D:GetForwardFromQuaternion(q)
    local x, y, z, w = q.x, q.y, q.z, q.w
    return CVector(
        2*(x*z + w*y),
        2*(y*z - w*x),
        1 - 2*(x*x + y*y)
    )
end

function I3D:GetEndOfBeam(origin, quaternion, distance)
	--базовое направление
	local baseDir = CVector(0,0,1)

	--вращение базового направления
	local rotatedDir = I3D:RotateCVectorByQuaternion(baseDir, quaternion)

	--нормализация для умножения
	rotatedDir = I3D:CVectorNormalize(rotatedDir)

	--точка окончания луча
	return CVector(
	    origin.x + rotatedDir.x * distance,
	    origin.y + rotatedDir.y * distance,
	    origin.z + rotatedDir.z * distance
	)
end

function I3D:GetFixedQuaternion(quaternion)
	--реальный forward и up (движок может дать инверсию или полную хуйню)
    local realForward = I3D:RotateCVectorByQuaternion(CVector(0,0,1), quaternion)
	local realUp = I3D:RotateCVectorByQuaternion(CVector(0,1,0), quaternion)
	realForward = I3D:CVectorNormalize(realForward)
    realUp = I3D:CVectorNormalize(realUp)

    --если forward или up получился нулевой/сломанный то ставим стандартный
    if realForward.x == 0 and realForward.y == 0 and realForward.z == 0 then
        realForward = CVector(0,0,1)
    end
	if realUp.x == 0 and realUp.y == 0 and realUp.z == 0 then
        realUp = CVector(0,1,0)
    end

    local forward = realForward
	local worldUp = realUp

    --если forward почти параллелен worldUp - происходит разрыв жопы
    --опорный up в критических случаях
    local dot = I3D:CVectorDot(forward, worldUp)
    if math.abs(dot) > 0.999 then
        worldUp = CVector(1,0,0) --альтернативный up
    end

    --правый вектор
    local right = I3D:CVectorCross(worldUp, forward)
    right = I3D:CVectorNormalize(right)

    --ортонормальный up
    local up = I3D:CVectorCross(forward, right)

    --матрица
    local m00 = right.x
    local m01 = right.y
    local m02 = right.z
    local m10 = up.x
    local m11 = up.y
    local m12 = up.z
    local m20 = forward.x
    local m21 = forward.y
    local m22 = forward.z

    local trace = m00 + m11 + m22
    local x,y,z,w = 0,0,0,1

    if trace > 0 then
        local s = math.sqrt(trace + 1.0) * 2
        w = 0.25 * s
        x = (m21 - m12) / s
        y = (m02 - m20) / s
        z = (m10 - m01) / s
    elseif (m00 > m11) and (m00 > m22) then
        local s = math.sqrt(1.0 + m00 - m11 - m22) * 2
        w = (m21 - m12) / s
        x = 0.25 * s
        y = (m01 + m10) / s
        z = (m02 + m20) / s
    elseif (m11 > m22) then
        local s = math.sqrt(1.0 + m11 - m00 - m22) * 2
        w = (m02 - m20) / s
        x = (m01 + m10) / s
        y = 0.25 * s
        z = (m12 + m21) / s
    else
        local s = math.sqrt(1.0 + m22 - m00 - m11) * 2
        w = (m10 - m01) / s
        x = (m02 + m20) / s
        y = (m12 + m21) / s
        z = 0.25 * s
    end

    return Quaternion(x, y, z, w)
end

function I3D:IsInCameraView(pos, region)
    --region = { left=-0.5, right=0.5, top=0.5, bottom=-0.5 }

    --позиция и ориентация камеры
    local camera_pos, camera_quat = I3D:GetCameraPos(), I3D:GetCameraRot()

    --воздать если нету
    local pos = pos or CVector(0,0,0)
    local fov_deg = I3D.FOV or I3D:UpdateScreenInfo().fov
	local window_w = I3D.WINDOW_W or I3D:UpdateScreenInfo().width
	local window_h = I3D.WINDOW_H or I3D:UpdateScreenInfo().height

    --оси камеры из quaternion
    local right, up, forward = I3D:QuaternionToAxes(camera_quat)

    --вертикальный fov через aspect ratio
    local aspect = window_h / window_w
    local hFOV = math.rad(fov_deg)
    local vFOV = 2 * math.atan(math.tan(hFOV * 0.5) * aspect)

    --вектор к позиции
    local to_entity = CVector(
        pos.x - camera_pos.x,
        pos.y - camera_pos.y,
        pos.z - camera_pos.z
    )

    --необязательно нормализовать!
    --потому что atan2(x,z) и atan2(y,z) работают корректно для любых масштабов
    local x = I3D:CVectorDot(right,   to_entity)
    local y = I3D:CVectorDot(up,      to_entity)
    local z = I3D:CVectorDot(forward, to_entity)

    --если объект за камерой
    if z <= 0 then 
        return false 
    end

    if not region then
        local half_hFOV = hFOV * 0.5
        local half_vFOV = vFOV * 0.5

        local horizontal_angle = math.abs(math.atan2(x, z))
        local vertical_angle   = math.abs(math.atan2(y, z))

        return (horizontal_angle <= half_hFOV) and (vertical_angle <= half_vFOV)
    else
        local tan_h = math.tan(hFOV * 0.5)
        local tan_v = math.tan(vFOV * 0.5)

        --NDC (от -1 до +1)
        local ndc_x = x / (z * tan_h)
        local ndc_y = y / (z * tan_v)

        --попадание в заданную область
        return (ndc_x >= region.left and ndc_x <= region.right and ndc_y >= region.bottom and ndc_y <= region.top)
    end
end

function I3D:IsInCameraViewSquared(pos, floatScopeCoeff)
	floatScopeCoeff = floatScopeCoeff or 1

	local pos = pos or CVector(0,0,0)
    local fov_deg = I3D.FOV or I3D:UpdateScreenInfo().fov
	local window_w = I3D.WINDOW_W or I3D:UpdateScreenInfo().width
	local window_h = I3D.WINDOW_H or I3D:UpdateScreenInfo().height

	local aspect = window_w / window_h

	local region = { 
		left = -floatScopeCoeff / aspect, 
		right = floatScopeCoeff / aspect, 
		top = floatScopeCoeff, 
		bottom = -floatScopeCoeff
	}

	return I3D:IsInCameraView(pos, region)
end

function I3D:IsObjectInCameraView(objEntity, floatScopeCoeff, boolSquareScope)
	if not objEntity then
		return nil
	end

	floatScopeCoeff = floatScopeCoeff or 1

	local entity_pos = objEntity:GetPosition() or CVector(0,0,0)

	if boolSquareScope and not type(floatScopeCoeff)=="table" then
		return I3D:IsInCameraViewSquared(entity_pos, floatScopeCoeff)
	else
		local region = {
			left = type(floatScopeCoeff)=="table" and floatScopeCoeff.left or floatScopeCoeff, 
			right = type(floatScopeCoeff)=="table" and floatScopeCoeff.right or floatScopeCoeff, 
			top = type(floatScopeCoeff)=="table" and floatScopeCoeff.top or floatScopeCoeff, 
			bottom = type(floatScopeCoeff)=="table" and floatScopeCoeff.bottom or floatScopeCoeff
		}
		return I3D:IsInCameraView(entity_pos, region)
	end
end

function I3D:GetMapSize()
	local mapsize = GET_GLOBAL_OBJECT( "CurrentLevel" ):GetLandSize()
	if mapsize==64 then
		mapsize = 8000
	elseif mapsize==32 then
		mapsize = 4000
	elseif mapsize==16 then
		mapsize = 2000
	elseif mapsize==8 then
		mapsize = 1000
	elseif mapsize==4 then
		mapsize = 500
	elseif mapsize==2 then
		mapsize = 250
	end
	return mapsize
end

function I3D:DrawVector(origin, quaternion, distance)
	local obstacle = false
	local pos = I3D:GetEndOfBeam(origin, quaternion, distance)
	if g_ObjCont:GetHeight(pos.x, pos.z) >= pos.y then
		--println("vector undergrounded!")
		obstacle = true
	end
	local mapsize = I3D:GetMapSize()
	if (pos.x>=mapsize or pos.y>=mapsize or pos.z>=mapsize) or (0>=pos.x or 0>=pos.y or 0>=pos.z) then
		--println("vector dropped out of the world!")
		obstacle = true
	end
	return pos, obstacle
end

function I3D:CVectorEulerToQuaternion(pitch, yaw, roll, bLOG)
	if bLOG==true then
        LOG("[I] Module Improved3D.lua === CVectorEulerToQuaternion(): Input x: "..tostring(yaw)..", y: "..tostring(pitch)..", z: "..tostring(roll))
	end
	local radPitch = math.rad(pitch)
	local radYaw = math.rad(yaw)
	local radRoll = math.rad(roll)

	local cy = math.cos(radYaw * 0.5)
	local sy = math.sin(radYaw * 0.5)
	local cp = math.cos(radPitch * 0.5)
	local sp = math.sin(radPitch * 0.5)
	local cr = math.cos(radRoll * 0.5)
	local sr = math.sin(radRoll * 0.5)

	local qw = cr * cp * cy + sr * sp * sy
	local qx = sr * cp * cy - cr * sp * sy
	local qy = cr * sp * cy + sr * cp * sy
	local qz = cr * cp * sy - sr * sp * cy

	if bLOG==true then
        LOG("[I] Module Improved3D.lua === CVectorEulerToQuaternion(): Got Quaternion"..tostring(Quaternion(qx, qy, qz, qw)))
	end

	return Quaternion(qx, qy, qz, qw)
end

function I3D:CVectorQuaternionToEuler(quaternion, bLOG)
    local x, y, z, w = quaternion.x, quaternion.y, quaternion.z, quaternion.w

	if bLOG==true then
		LOG("[I] Module Improved3D.lua === CVectorQuaternionToEuler(): Input Quaternion"..tostring(Quaternion(x, y, z, w)))
	end

    --"Настоящий" yaw (вокруг Y, по горизонтали)
    local siny_cosp = 2 * (w * y + z * x)
    local cosy_cosp = 1 - 2 * (x * x + y * y)
    local yaw = math.atan2(siny_cosp, cosy_cosp)

    --"Настоящий" pitch (вверх-вниз)
    local sinp = 2 * (w * x - y * z)
    if sinp > 1 then sinp = 1 end
    if sinp < -1 then sinp = -1 end
    local pitch = math.asin(sinp)

    --roll (вокруг Z - наклон головы)
    local sinr_cosp = 2 * (w * z + x * y)
    local cosr_cosp = 1 - 2 * (y * y + z * z)
    local roll = math.atan2(sinr_cosp, cosr_cosp)

	if bLOG==true then
		LOG("[I] Module Improved3D.lua === CVectorQuaternionToEuler(): Got x: "..math.deg(yaw)..", y: "..math.deg(pitch)..", z: "..math.deg(roll))
	end

	return math.deg(pitch), math.deg(yaw), math.deg(roll)
end

function I3D:EulerToQuaternion(x,y,z,bLOG)
	if bLOG==true then
		LOG("[I] Module Improved3D.lua === EulerToQuaternion(): Input x: "..tostring(x)..", y: "..tostring(y)..", z: "..tostring(z))
	end
	--Преобразуем углы Эйлера из градусов в радианы
    local roll_rad = math.rad(x)
    local pitch_rad = math.rad(y)
    local yaw_rad = math.rad(z)

    --Вычисляем половины углов
    local halfRoll = roll_rad * 0.5
    local halfPitch = pitch_rad * 0.5
    local halfYaw = yaw_rad * 0.5

    --Вычисляем синусы и косинусы половины углов
    local cosRoll = math.cos(halfRoll)
    local sinRoll = math.sin(halfRoll)
    local cosPitch = math.cos(halfPitch)
    local sinPitch = math.sin(halfPitch)
    local cosYaw = math.cos(halfYaw)
    local sinYaw = math.sin(halfYaw)

    --Вычисляем кватернион
    local w = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw
    local x = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw
    local y = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw
    local z = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw

	--Результат Quaternion(w,x,y,z) будет неверным.
	--В игре по умолчанию объекты смотрят на север и стандартное вращение (то бишь на север) равняется Quaternion(0,0,0,1)
	--Соответственно правильно будет Quaternion(x,y,z,w) при нулях на входе.
	--println(EulerToQuaternion(0,0,0))

	if bLOG==true then
		LOG("[I] Module Improved3D.lua === EulerToQuaternion(): Got Quaternion"..tostring(Quaternion(x,y,z,w)))
	end
	return Quaternion(x,y,z,w)
end

function I3D:QuaternionToEuler(quaternion,bLOG)
    local x, y, z, w = quaternion.x, quaternion.y, quaternion.z, quaternion.w
	if bLOG==true then
		LOG("[I] Module Improved3D.lua === QuaternionToEuler(): Input Quaternion"..tostring(Quaternion(x,y,z,w)))
	end
	--Вычисляем углы Эйлера (в радианах)
	--println("x "..x)
	--println("y "..y)
	--println("z "..z)
	--println("w "..w)
    local pitch = math.asin(2 * (w * y - z * x))

    --Проверяем, не вызывает ли это выход за пределы -1 и 1
	--println("pit "..pitch)
	--println("abs "..math.abs(pitch))
    if (math.abs(pitch) == (math.pi / 2)) or (math.abs(pitch) == -(math.pi / 2)) then
	--if math.abs(pitch) == (math.pi / 2) then
    --if math.abs(pitch)>=(-1.0000000001) or (-1.0000000001)>=math.abs(pitch) then
        local roll = 0
        local yaw = math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))
        --Возвращаем углы Эйлера в градусах
		--println("qqqqqqqqqqqqqqqqqqq")
		if bLOG==true then
			LOG("[I] Module Improved3D.lua === QuaternionToEuler(): Got x: "..math.deg(roll)..", y: "..math.deg(pitch)..", z: "..math.deg(yaw))
		end
		return math.deg(roll), math.deg(pitch), math.deg(yaw)
    end

    local roll = math.atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))
    local yaw = math.atan2(2 * (w * z + x * y), 1 - 2 * (z * z + y * y))

    --Возвращаем углы Эйлера в градусах
	if bLOG==true then
		LOG("[I] Module Improved3D.lua === QuaternionToEuler(): Got x: "..math.deg(roll)..", y: "..math.deg(pitch)..", z: "..math.deg(yaw))
	end
    return math.deg(roll), math.deg(pitch), math.deg(yaw)
end

function I3D:ParseCVector(CVector)
	CVector = tostring(CVector)
	if not string.find(CVector, "%(") then
		CVector = "("..CVector..")"
	end
	if not string.find(CVector, ",") then
		CVector = string.gsub(CVector, " ", ", ")
	end
	local userdata = dostring("local p = CVector"..CVector.."; return p")
	return userdata
end

function I3D:CallEntityInZone(posVector, floatZoneSize, boolGetsIntoCamera)
	local Entity
	local posVector = posVector or I3D:GetCameraPos()
	local floatZoneSize = floatZoneSize or 10
	GLOBAL_ENTITIES_ON_MAP = GLOBAL_ENTITIES_ON_MAP or I3D:GetAllEntities(boolGetsIntoCamera)
	GLOBAL_ENTITIES_ON_MAP_SIZE = GLOBAL_ENTITIES_ON_MAP_SIZE or getn(GLOBAL_ENTITIES_ON_MAP)
	local v, z = posVector, floatZoneSize
	local e = nil
	for i, entity in ipairs(GLOBAL_ENTITIES_ON_MAP) do
		e = entity:GetPosition()
		if ((v.x+z>=e.x) and (e.x>=v.x-z)) and ((v.y+z>=e.y) and (e.y>=v.y-z)) and ((v.z+z>=e.z) and (e.z>=v.z-z)) then
			Entity = entity
			break
		end
	end

	return Entity
end

function I3D:GetAllEntities(boolGetsIntoCamera)
	GLOBAL_ENTITIES_ON_MAP_SIZE = 0
	GLOBAL_ENTITIES_ON_MAP = {}
	if g_ObjCont then
		local size = g_ObjCont:size()
		GLOBAL_ENTITIES_ON_MAP_SIZE = size
		for i=1, size do
			local entity = GetEntityByID(i)
			if entity then
				local _, entity_pos = pcall(function() return entity:GetPosition() end)
				if entity_pos and type(entity_pos)=="userdata" then
					if boolGetsIntoCamera then
						if I3D:IsInCameraView(entity_pos) then
							table.insert(GLOBAL_ENTITIES_ON_MAP, entity)
						end
					else
						table.insert(GLOBAL_ENTITIES_ON_MAP, entity)
					end
				end
			end
		end
	end
	return GLOBAL_ENTITIES_ON_MAP, GLOBAL_ENTITIES_ON_MAP_SIZE
end



-- /////////////////////////// RETURN MODULE ////////////////////////////////

LOG("[I] Module Improved3D.lua "..I3D.version.." successfully loaded.")

return I3D