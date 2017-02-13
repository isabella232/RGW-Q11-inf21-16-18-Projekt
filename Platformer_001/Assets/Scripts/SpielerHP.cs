﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

public class SpielerHP : MonoBehaviour {
	[Header("Werte")]
	[Range(0, 100)]
	public int hp = 100;
	public int maxHP = 100;

	[Header("Events")]
    public EventTrigger.TriggerEvent schadenEvent;
    public EventTrigger.TriggerEvent todEvent;

    public HUDHPAnzeige hpAnzeige;

    void Start() {
        if (hpAnzeige != null) hpAnzeige.HPSetzen(hp);
    }

	public void SchadenZufuegen(int schaden) {
        hp = Math.Max(hp - schaden, 0);

        if (hp <= 0) {
            todEvent.Invoke(null);
        } else {
            schadenEvent.Invoke(null);
        }

        if (hpAnzeige != null) hpAnzeige.HPSetzen(hp);
    }

    public void Heilen(int hp) {
        this.hp = hp + Math.Min(maxHP, hp);
    }
}
