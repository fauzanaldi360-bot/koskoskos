<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->integer('price_daily')->default(0);
            $table->integer('price_weekly')->default(0);
            $table->string('whatsapp_number')->default('6281234567890');
            $table->enum('status', ['available', 'maintenance'])->default('available');
            $table->text('room_description')->nullable();
            // Profil Usaha
            $table->string('brand_name')->default('Kost Harmoni Group');
            $table->string('email')->default('admin@harmonigroup.com');
            $table->string('whatsapp')->default('081234567890');
            $table->string('bank_account')->default('BCA 1234567890 a.n. Harmoni Group');
            // Aturan Billing & Denda
            $table->integer('billing_date')->default(1);
            $table->enum('penalty_type', ['flat', 'percentage'])->default('flat');
            $table->integer('penalty_amount')->default(50000);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('settings');
    }
};
