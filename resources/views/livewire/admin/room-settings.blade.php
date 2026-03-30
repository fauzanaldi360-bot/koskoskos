<div class="space-y-6">
    <!-- Header -->
    <div>
        <h1 class="text-2xl font-bold text-white">Pengaturan</h1>
        <p class="text-gray-400 text-sm mt-1">Kelola profil usaha dan preferensi.</p>
    </div>

    @if(session('success'))
        <div class="mb-4 px-4 py-3 bg-green-500/10 border border-green-500/20 text-green-400 rounded-xl text-sm font-medium">
            {{ session('success') }}
        </div>
    @endif

    <!-- Main Card -->
    <div class="bg-[#111827] border border-gray-800/50 rounded-2xl p-6">
        <form wire:submit="save" class="space-y-8">
            
            <!-- Profil Usaha -->
            <div>
                <div class="flex items-center gap-2 mb-4">
                    <svg class="w-5 h-5 text-[#0d9488]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                    </svg>
                    <h2 class="text-white font-semibold">Profil Usaha</h2>
                </div>

                <div class="space-y-4">
                    <!-- Nama Brand -->
                    <div>
                        <label class="block text-sm text-gray-400 mb-2">Nama Brand</label>
                        <input type="text" wire:model="brand_name" class="w-full bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]" placeholder="Kost Harmoni Group">
                    </div>

                    <!-- Email Kontak -->
                    <div>
                        <label class="block text-sm text-gray-400 mb-2">Email Kontak</label>
                        <input type="email" wire:model="email" class="w-full bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]" placeholder="admin@harmonigroup.com">
                    </div>

                    <!-- No. WhatsApp -->
                    <div>
                        <label class="block text-sm text-gray-400 mb-2">No. WhatsApp</label>
                        <input type="text" wire:model="whatsapp" class="w-full bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]" placeholder="081234567890">
                    </div>

                    <!-- Rekening Bank -->
                    <div>
                        <label class="block text-sm text-gray-400 mb-2">Rekening Bank</label>
                        <input type="text" wire:model="bank_account" class="w-full bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]" placeholder="BCA 1234567890 a.n. Harmoni Group">
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="border-t border-gray-800/50"></div>

            <!-- Aturan Billing & Denda -->
            <div>
                <h2 class="text-white font-semibold mb-4">Aturan Billing & Denda</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Tanggal Billing -->
                    <div>
                        <label class="block text-sm text-gray-400 mb-2">Tanggal Billing</label>
                        <input type="number" wire:model="billing_date" min="1" max="31" class="w-full bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]" placeholder="1">
                    </div>

                    <!-- Tipe Denda -->
                    <div>
                        <label class="block text-sm text-gray-400 mb-2">Tipe Denda</label>
                        <select wire:model="penalty_type" class="w-full bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]">
                            <option value="flat">Flat (Rp/hari)</option>
                            <option value="percentage">Persentase (%)</option>
                        </select>
                    </div>

                    <!-- Denda/Hari -->
                    <div class="md:col-span-2">
                        <label class="block text-sm text-gray-400 mb-2">Denda/Hari (Rp)</label>
                        <input type="number" wire:model="penalty_amount" class="w-full md:w-1/2 bg-[#0f172a] border border-gray-700 rounded-xl px-4 py-3 text-white text-sm focus:outline-none focus:border-[#0d9488]" placeholder="50000">
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <div class="flex justify-end pt-4">
                <button type="submit" class="inline-flex items-center gap-2 px-6 py-3 bg-[#0d9488] hover:bg-[#0f766e] text-white rounded-xl text-sm font-semibold transition-colors">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4"/>
                    </svg>
                    Simpan Pengaturan
                </button>
            </div>
        </form>
    </div>
</div>
