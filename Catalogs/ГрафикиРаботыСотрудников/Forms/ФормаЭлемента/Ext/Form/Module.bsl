﻿&НаКлиенте
Процедура УправлениеДоступностью()
	ЭтоЦикличныйГрафик = Объект.СпособЗаполнения = 2;
	Элементы.ШагДней.Доступность = ЭтоЦикличныйГрафик;
	Элементы.НачалоГрафика.Доступность = ЭтоЦикличныйГрафик;
КонецПроцедуры

&НаКлиенте
Процедура СпособЗаполненияПриИзменении(Элемент)
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаКорректностиПериода()
	Если ЗначениеЗаполнено(Объект.КонецПериода) И Объект.НачалоПериода > Объект.КонецПериода Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Начало периода не может быть больше окончания!";
		Сообщение.Сообщить();
		Объект.КонецПериода = '00010101';
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ПроверкаКорректностиПериода();
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ПроверкаКорректностиПериода();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.НачалоПериода = '00010101' И Объект.КонецПериода = '00010101' Тогда
		Объект.НачалоПериода = НачалоГода(ТекущаяДата());
		Объект.КонецПериода = КонецГода(ТекущаяДата());
	КонецЕсли;
	Если Объект.СпособЗаполнения = 0 Тогда
		Объект.СпособЗаполнения = 1;
	КонецЕсли;
	Если Объект.НачалоГрафика = 0 Тогда
		Объект.НачалоГрафика = 1;
	КонецЕсли;
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГрафикПятидневки()
	СуткиВСекундах = 86400;
	ТекущийДень = Объект.НачалоПериода;
	Пока ТекущийДень <= Объект.КонецПериода Цикл
		НоваяСтрока = Объект.СписокДней.Добавить();
		НоваяСтрока.День = ТекущийДень;
		ЭтоРабочийДень = (ДеньНедели(ТекущийДень) < 6);
		Если ЭтоРабочийДень Тогда
			НоваяСтрока.КоличествоЧасов = Объект.КоличествоЧасов;
		КонецЕсли;
		ТекущийДень = ТекущийДень + СуткиВСекундах;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦиклическийГрафик()
	СуткиВСекундах = 86400;
	ТекущийДень = Объект.НачалоПериода;
	Если Объект.НачалоГрафика = 1 Тогда
		ЭтоРабочийДень = Истина;
	Иначе
		ЭтоРабочийДень = Ложь;
	КонецЕсли;
	Сч = 0;
	Пока ТекущийДень <= Объект.КонецПериода Цикл
		НоваяСтрока = Объект.СписокДней.Добавить();
		НоваяСтрока.День = ТекущийДень;
		Если ЭтоРабочийДень Тогда
			НоваяСтрока.КоличествоЧасов = Объект.КоличествоЧасов;
		КонецЕсли;
		Сч = Сч + 1;
		ТекущийДень = ТекущийДень + СуткиВСекундах;
		Если Сч % Объект.ШагДней = 0 Тогда
			ЭтоРабочийДень = Не ЭтоРабочийДень;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГрафик(Команда)
	Объект.СписокДней.Очистить();
	Если Объект.СпособЗаполнения = 1 Тогда
		ЗаполнитьГрафикПятидневки();
	ИначеЕсли Объект.СпособЗаполнения = 2 Тогда
		ЗаполнитьЦиклическийГрафик();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВГрафикиПредприятияНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ГрафикиРаботыСотрудниковСписокДней.День КАК День,
	|	ГрафикиРаботыСотрудниковСписокДней.КоличествоЧасов КАК КоличествоЧасов,
	|	ГрафикиРаботыСотрудниковСписокДней.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГрафикиРаботыСотрудников.СписокДней КАК ГрафикиРаботыСотрудниковСписокДней
	|ГДЕ
	|	ГрафикиРаботыСотрудниковСписокДней.КоличествоЧасов > 0
	|	И ГрафикиРаботыСотрудниковСписокДней.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ДанныеГрафика = Запрос.Выполнить().Выгрузить();
	РегистрыСведений.ГрафикиРаботыПредприятия.ЗаполнитьГрафики(ДанныеГрафика);
	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = СтрШаблон("График работы %1 успешно загружен.", Объект.Наименование);
	СообщениеПользователю.Сообщить();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВГрафикиПредприятия(Команда)
	Если Объект.СписокДней.Количество() > 0 Тогда
		ЗагрузитьВГрафикиПредприятияНаСервере();
	Иначе
		Сообщить("График работы не содержит данных, сначала заполните график работы!");
	КонецЕсли;
КонецПроцедуры



