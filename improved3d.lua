-- ============================================================
-- ============================================================
-- 
-- 
--                ПРОСТРАНСТВЕННЫЙ LUA-МОДУЛЬ,
-- 
--               написанный специально для игры
--             Ex Machina / Hard Truck Apocalypse
--
--                     Improved3D v1.0
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
-- удобно размещать и вращать объекты, пользоваться некоторыми 
-- техническими возможностями, что не могла сделать сама игра из 
-- доступных публичных методов.
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
--     i3d = require("data\\gamedata\\lua_lib\\improved3d.lua")
--     if not i3d then
--         LOG("[E] Could not find global Improved3D.lua...")
--     end
-- ]]
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
--      Обратите внимание, что дочерний класс должен вызывать 
-- главный метод своего родительского класса вплоть до I3D.
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
--       [M] Quaternion SetObjectLookAt( object SetAim, object GetAim, bool OnlyYaw, bool LockRoll )  /* Обращает взор первого объекта на позицию второго объекта - как аим камеры в катсценах. Для плавной работы необходимо вызывать каждый раз: objSetAim = объект, который нужно повернуть; objGetAim = объект или позиция, на которую надо "смотреть": может быть getObj(), CVector(), GetCameraPos(); boolOnlyYaw = применяется вращение только по оси Y (как турель), если true; boolLockRoll = запрещается вращение по оси Z (наклон), если true. Примеры: SetObjectLookAt(getObj("aim_object_name"), GetPlayerVehicle(), false, true) --> Аим на объект; SetObjectLookAt(getObj("aim_object_name"), GetCameraPos(), false, true) --> Аим на камеру */
--       [M] void IsCameraLookAt( float DrawVectorQuant, float DrawVectorQuantMultiplier, float DrawVectorMinDistance, float DrawVectorMaxDistance, float DrawCatchZoneSize )        /* Смотрит ли куда-то камера? Бросает луч из камеры и пытается что-то "нащупать" (работает с триггером "IsCameraLookAt_VectorDrawer" или с IsCameraLookAt_VectorDrawer_f()): float DrawVectorQuant = шаг построения отрезка луча (в метрах); float DrawVectorQuantMultiplier = множитель шага построения отрезка луча (1.0); float DrawVectorMinDistance = минимальное расстояние, после которого идет захват объекта лучом (в метрах); float DrawVectorMaxDistance		= максимальное расстояние захвата объектов лучом (в метрах); float DrawCatchZoneSize = размер зоны захвата объектов в точке луча (в метрах); Пример: i3d:IsCameraLookAt(5,1,20,1000,5) */
--       [M] ??? IsCameraLookAt_Callback( CVector pos, Object entity )       /* Настраивается пользователем. Эта callback-функция вызывается GetCameraLookAtProcess, когда он завершается. Нужна как обработка ивента окончания работы луча. Аргументы возвращает сам GetCameraLookAtProcess: pos = CVector точки, куда смотрела камера на момент вызова IsCameraLookAt(); entity = Object сущности, какую захватил луч, может быть nil. Доступен такой же контроль, как через GetEntityByName() */
--       [M] bool IsInCameraView( CVector pos, float fov_deg, int window_w, int window_h, table region )   /* Находится ли точка в поле зрения камеры с fov и размерами окна игры. Пытается взять window из конфига игры если nil. Может принять границы захвата region на экране пропорционально с left, right, bottom, top (от -1 до 1) */
--       [M] CVector RotateAroundPoint( CVector 1, CVector 2, Quaternion or tableRotation )  /* Возвращает  точку повернутого вектора2 вокруг вектора1 на угол tableRotation [{90,0,0}] или Quaternion() */
--       [M] CVector LinearMoveAroundPoint( CVector 1_old, CVector 1_new, CVector 2_old )    /* Возвращает точку сдвинутого вектора2 линейно вместе с вектором1: 1_old = последняя сохраненная позиция вектора1; 1_new	= новая позиция вектора1; 2_old	= последняя сохраненная позиция вектора2 */
--       [M] CVector AdjustDistanceBetweenVectors( CVector 1_old, CVector 2_old, float target_dist )     /* Возвращает точку вектора2 на нужном расстоянии от вектора1: 1_old = последняя сохраненная позиция вектора1; 2_old = последняя сохраненная позиция вектора2; target_dist = требуемое расстояние между векторами */
--       [M] CVector GetEndOfBeam( CVector origin, Quaternion, float distance )      /* Возвращает точку на расстоянии distance от origin, направленную по вращению quaternion */
--       [M] CVector&boolObstacle DrawVector( CVector origin, Quaternion, float distance )   /* Рисует вектор в игровом мире длиной distance от origin, направленного по вращению quaternion и возвращает его вторую точку (воспринимает препятствия в виде ландшафта и края карты) */
--       [M] Object CallEntityInZone( CVector pos, float ZoneSize, bool GetsIntoCamera )     /* Возвращает объект, что находится в желаемой точке: posVector = CVector точки, позиция камеры если nil; float ZoneSize = размер зоны у точки, в которой может быть объект (в метрах); bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true */
--       [M] table GetAllEntities( bool GetsIntoCamera )         /* Возвращает все объекты на карте, что имеют позиции CVector и их количество: bool GetsIntoCamera = захватывает только объекты, что могут быть спереди камеры если true */
--
--       /* Помощь в расчетах */
--       [M] CVector ParseCVector( string CVector )      /* Возвращает CVector из строки с CVector (юзердату) */
--       [M] Quaternion EulerToQuaternion( float x, float y, float z, bool LOG ) /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. */
--       [M] EulerX&EulerY&EulerZ QuaternionToEuler( Quaternion, bool LOG )      /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. */
--       [M] Quaternion GetFixedQuaternion( Quaternion )         /* Возвращает исправленное вращение. Как понять, что ваше вращение понос спидозного бомжа? - объект хуй пойми куда смотрит, а не куда ему нужно */
--       [M] Quaternion QuaternionFromTo( CVector From, CVector To )     /* Возвращает кватернион от вектора к вектору (вращение из одного направления в другое) */
--       [M] CVector RotateCVectorByQuaternion( CVector, Quaternion )    /* Возвращает точку помноженного вектора на кватернион (поворот CVector по вращению Quaternion) */
--       [M] CVectorX&CVectorY&CVectorZ QuaternionToAxes( Quaternion )   /* Возвращает направления по осям из кватерниона */
--       [M] CVector CVectorAverage( table CVectors, bool Y )    /* Возвращает точку как среднее арифметическое векторов, считает Y если true */
--       [M] CVector GetForwardFromQuaternion( Quaternion )      /* Возвращает направление "вперед" из вращения */
--       [M] float CVectorDot( CVector 1, CVector 2 )            /* Возвращает скалярное произведение двух векторов */
--       [M] CVector CVectorCross( CVector 1, CVector 2 )        /* Возвращает точку векторного произведения двух векторов */
--       [M] CVector CVectorNormalize( CVector )         /* Возвращает нормализацию вектора */
--       [M] int GetMapKilometers()       /* Возвращает константу размера текущей карты в километрах */
--
--       /* Сервисные функции. По возможности не используйте */
--       [M] CVector&Object IsCameraLookAt_VectorDrawer_f()      /* Функция вместо триггера "IsCameraLookAt_VectorDrawer". Плюсы: Луч строится мгновенно; Минусы: Экс Машина */
--       [M] Quaternion CVectorEulerToQuaternion( float pitch, float yaw, float roll, bool LOG )     /* Преобразует углы Эйлера (градусы) в углы кватерниона. Принтит в лог результат, если bool LOG = true. Используйте на входе: pitch = y, yaw = z, roll = x */
--       [M] EulerX&EulerY&EulerZ CVectorQuaternionToEuler( Quaternion, bool LOG )   /* Преобразует углы кватерниона в углы Эйлера (градусы). Принтит в лог результат, если bool LOG = true. Используйте на выходе pitch = y, yaw = z, roll = x. */
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
--             local pos, obstacle = i3d:DrawVector(GL_LookAtCVector, GL_LookAtQuaternion, GL_LookAtDistance)
--             GL_LookAtDistance = GL_LookAtDistance * GL_LookAtDistanceCoeff
--             GL_LookAtCVector = pos
--             local entity = nil
--             if (skoka * GL_LookAtDistance>=GL_LookAtDistanceMin) then
--                 entity = i3d:CallEntityInZone(pos, GL_LookAtZoneSize)
--             end
--             if obstacle or entity or (skoka * GL_LookAtDistance>=GL_LookAtDistanceMax) then
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
-- ============================================================
-- ============================================================




-- //////////////////////////// MODULE INIT /////////////////////////////////


local I3D = {}
I3D.__index = I3D
I3D.version = "v1.0"

LOG("[I] Init Module Improved3D.lua ...")

if not g_ObjCont then
    LOG("[E] Module Improved3D.lua === g_ObjCont not found!!!")
    return
end

-- ////////////////////////// USER EDITABLE FUNCTIONS ////////////////////////////


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

-- //////////////////////// GLOBAL MODULE FUNCTIONS //////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////



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

function I3D:IsCameraLookAt(floatDrawVectorQuant, floatDrawVectorQuantMultiplier, floatDrawVectorMinDistance, floatDrawVectorMaxDistance, floatDrawCatchZoneSize)
	GL_LookAtCVector, GL_LookAtQuaternion = GetCameraPos()
	GL_LookAtStartCVector = GL_LookAtCVector
	GL_LookAtQuaternion = I3D:GetFixedQuaternion(GL_LookAtQuaternion)
	GL_LookAtDistance = floatDrawVectorQuant or 5
	GL_LookAtZoneSize = floatDrawCatchZoneSize or 5
	GL_LookAtDistanceCoeff = floatDrawVectorQuantMultiplier or 1.000
	GL_LookAtDistanceMin = floatDrawVectorMinDistance or 0
	GL_LookAtDistanceMax = floatDrawVectorMaxDistance or I3D:GetMapKilometers()
	
	--сброс эффекта для демонстрации точки, куда смотрит камера
	local LookAtEffect = getObj("IsCameraLookAtEffect")
	if LookAtEffect then LookAtEffect:Remove() end

	TDeactivate("IsCameraLookAt_VectorDrawer")

	_G["GetCameraLookAtProcess"] = coroutine.create(function()
		I3D:GetAllEntities()
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
		pos, obstacle = I3D:DrawVector(GL_LookAtCVector, GL_LookAtQuaternion, GL_LookAtDistance)
		GL_LookAtDistance = GL_LookAtDistance * GL_LookAtDistanceCoeff
		GL_LookAtCVector = pos
		if (skoka * GL_LookAtDistance>=GL_LookAtDistanceMin) then
			entity = I3D:CallEntityInZone(pos, GL_LookAtZoneSize)
		end
		if obstacle or entity or (skoka * GL_LookAtDistance>=GL_LookAtDistanceMax) then
			break
		end
	until obstacle or entity or (skoka * GL_LookAtDistance>=GL_LookAtDistanceMax)
	
	return pos, entity
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
    --нормализуем quaternion
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

local function _GetFromConfig(stringParamName)
	local value
	local f = io.open("data\\config.cfg", "r")
	if f then
		local data = f:read("*all")
		f:close()
		_,_, value = string.find(data, stringParamName..'%s*=%s*"([^"]*)"')
	end
	return value
end

function I3D:IsInCameraView(pos, fov_deg, window_w, window_h, region)
    --region = { left=-0.5, right=0.5, top=0.5, bottom=-0.5 }

    --позиция и ориентация камеры
    local camera_pos, camera_quat = GetCameraPos()
    camera_quat = I3D:GetFixedQuaternion(camera_quat)

    --воздать если нету
    pos = pos or CVector(0,0,0)
    fov_deg = fov_deg or tonumber(_GetFromConfig("fov")) or 70
	window_w = window_w or tonumber(_GetFromConfig("r_width")) or 1920
	window_h = window_h or tonumber(_GetFromConfig("r_height")) or 1080

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

function I3D:GetMapKilometers()
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
	local mapsize = I3D:GetMapKilometers()
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
	--EXPRINT("x "..x)
	--EXPRINT("y "..y)
	--EXPRINT("z "..z)
	--EXPRINT("w "..w)
    local pitch = math.asin(2 * (w * y - z * x))

    --Проверяем, не вызывает ли это выход за пределы -1 и 1
	--EXPRINT("pit "..pitch)
	--EXPRINT("abs "..math.abs(pitch))
    if (math.abs(pitch) == (math.pi / 2)) or (math.abs(pitch) == -(math.pi / 2)) then
	--if math.abs(pitch) == (math.pi / 2) then
    --if math.abs(pitch)>=(-1.0000000001) or (-1.0000000001)>=math.abs(pitch) then
        local roll = 0
        local yaw = math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))
        --Возвращаем углы Эйлера в градусах
		--EXPRINT("qqqqqqqqqqqqqqqqqqq")
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
	local posVector = posVector or GetCameraPos()
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
				local _, entity_pos = try(function() return entity:GetPosition() end)
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