﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	МассивОчищаемыхРеквизитов = Новый Массив;
	Если (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя"))
		И ЗначениеЗаполнено(Объект.Плательщик) Тогда
		МассивОчищаемыхРеквизитов.Добавить("Плательщик");
		МассивОчищаемыхРеквизитов.Добавить("Договор");
		ТекстВопроса = "При изменении реквизита ""Вид операции"" будут очищены следующие данные:
		| - Плательщик (Если поле было доступно для заполнения)
		| - Договор (Если поле было доступно для заполнения)
		| - Продолжить?";
	КонецЕсли;
	Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбИзмененииВидаОперации", ЭтаФорма, МассивОчищаемыхРеквизитов);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, "Внимание!");
	Иначе
		ВидОперации = Объект.ВидОперации;
		УстановитьВидимость();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОбИзмененииВидаОперации(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для Каждого Реквизит Из ДополнительныеПараметры Цикл
			Объект[Реквизит] = Неопределено;
		КонецЦикла;
		УстановитьВидимость();
	Иначе
		Объект.ВидОперации = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	СтрокаТипПлательщика = "";
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника") Тогда
		Элементы.Договор.Видимость = Ложь;
		СтрокаТипПлательщика = "СправочникСсылка.Сотрудники";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика") Тогда
		Элементы.Договор.Видимость = Истина;
		СтрокаТипПлательщика = "СправочникСсылка.Контрагенты";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя") Тогда
		Элементы.Договор.Видимость = Истина;
		СтрокаТипПлательщика = "СправочникСсылка.Контрагенты";
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаТипПлательщика) Тогда
		Массив = Новый Массив();
		Массив.Добавить(Тип(СтрокаТипПлательщика));
		ОписаниеТипаПлательщика = Новый ОписаниеТипов(Массив);
		Элементы.Плательщик.ОграничениеТипа = ОписаниеТипаПлательщика;
	КонецЕсли;
	Если Элементы.Договор.Видимость = Истина И ЗначениеЗаполнено(Объект.Плательщик) Тогда
		Элементы.Договор.Видимость = ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Объект.Плательщик);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Плательщик)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Плательщик", Плательщик);
	Запрос.Текст = "ВЫБРАТЬ
	|	Контрагенты.ТипКонтрагента КАК ТипКонтрагента,
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Плательщик";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Если ЗначениеЗаполнено(Выборка.ТипКонтрагента)
		И Выборка.ТипКонтрагента = Перечисления.ТипыКонтрагентов.Клиент Тогда
		возврат Ложь;
	Иначе
		возврат Истина;
	КонецЕсли;
КонецФункции