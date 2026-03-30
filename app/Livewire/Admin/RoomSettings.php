<?php

namespace App\Livewire\Admin;

use App\Models\Setting;
use Livewire\Component;

class RoomSettings extends Component
{
    // Profil Usaha
    public $brand_name = '';
    public $email = '';
    public $whatsapp = '';
    public $bank_account = '';

    // Aturan Billing & Denda
    public $billing_date = 1;
    public $penalty_type = 'flat';
    public $penalty_amount = 50000;

    public function mount()
    {
        $setting = Setting::first();
        if ($setting) {
            $this->brand_name = $setting->brand_name ?? 'Kost Harmoni Group';
            $this->email = $setting->email ?? 'admin@harmonigroup.com';
            $this->whatsapp = $setting->whatsapp ?? '081234567890';
            $this->bank_account = $setting->bank_account ?? 'BCA 1234567890 a.n. Harmoni Group';
            $this->billing_date = $setting->billing_date ?? 1;
            $this->penalty_type = $setting->penalty_type ?? 'flat';
            $this->penalty_amount = $setting->penalty_amount ?? 50000;
        } else {
            $this->brand_name = 'Kost Harmoni Group';
            $this->email = 'admin@harmonigroup.com';
            $this->whatsapp = '081234567890';
            $this->bank_account = 'BCA 1234567890 a.n. Harmoni Group';
            $this->billing_date = 1;
            $this->penalty_type = 'flat';
            $this->penalty_amount = 50000;
        }
    }

    public function save()
    {
        $setting = Setting::first();
        if (!$setting) {
            $setting = new Setting();
        }

        $setting->brand_name = $this->brand_name;
        $setting->email = $this->email;
        $setting->whatsapp = $this->whatsapp;
        $setting->bank_account = $this->bank_account;
        $setting->billing_date = $this->billing_date;
        $setting->penalty_type = $this->penalty_type;
        $setting->penalty_amount = $this->penalty_amount;
        $setting->save();

        session()->flash('success', 'Pengaturan berhasil disimpan!');
    }

    public function render()
    {
        return view('livewire.admin.room-settings')->layout('layouts.admin', ['title' => 'Pengaturan']);
    }
}
