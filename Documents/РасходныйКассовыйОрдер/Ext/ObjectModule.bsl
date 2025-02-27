﻿Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ДенежныеСредства.Записывать = Истина;
	Движение = Движения.ДенежныеСредства.ДобавитьРасход();
	Движение.Период = Дата;
	Движение.Касса = Касса;
	Движение.Сумма = СуммаДокумента;
	АналитикаПроводки = ПолучитьАналитикуПроводки();
	Движения.Хозрасчетный.Записывать = Истина;
	Движение = Движения.Хозрасчетный.Добавить();
	Движение.СчетДт = АналитикаПроводки.СчетДебета;
	Движение.СчетКт = АналитикаПроводки.СчетКредита;
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = АналитикаПроводки.СодержаниеОперации;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, АналитикаПроводки.СубконтоДебет);
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, АналитикаПроводки.СубконтоКредит);
	Движения.Записать();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Реализация") Тогда
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВозвратПокупателю");
		Договор = ДанныеЗаполнения.Договор;
		Получатель = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровИУслуг") Тогда
		Договор = ДанныеЗаполнения.Договор;
		Получатель = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ОплатаПоставщику");
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьАналитикуПроводки()
    ОплатаПоставщику = Перечисления.ВидыОперацийРасходаДенег.ОплатаПоставщику;
    ВозвратДенегПокупателю = Перечисления.ВидыОперацийРасходаДенег.ВозвратПокупателю;
    ВыдачаДенегПодотчетнику = Перечисления.ВидыОперацийРасходаДенег.ВыдачаПодотчетнику;
	ВыдачаЗаработнойПлаты = Перечисления.ВидыОперацийРасходаДенег.ВыдачаЗаработнойПлаты;
    СтруктураАналитики = Новый Структура;
    СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.Касса);
    СтруктураАналитики.Вставить("СубконтоКредит", Касса);
    Если ВидОперации = ОплатаПоставщику Тогда
        СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками);
        СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Оплата поставщику наличными из кассы");
    ИначеЕсли ВидОперации = ВозвратДенегПокупателю Тогда
        СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);    
        СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат покупателю наличными из кассы");
    ИначеЕсли ВидОперации = ВыдачаДенегПодотчетнику Тогда
        СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами);
        СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Выдача денежных средств подотчетному лицу");
	ИначеЕсли ВидОперации = ВыдачаЗаработнойПлаты Тогда
        СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда);
        СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Выплата заработной платы наличными из кассы");	
	КонецЕсли;
    Возврат СтруктураАналитики;   
КонецФункции
