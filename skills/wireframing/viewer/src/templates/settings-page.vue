<script setup>
import { ref } from 'vue'
import { Card, CardContent, CardHeader, CardFooter } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'

const activeSection = ref('profile')

const navSections = [
  {
    heading: 'ACCOUNT',
    items: [
      { id: 'profile', label: 'Profile' },
      { id: 'appearance', label: 'Appearance' },
      { id: 'language', label: 'Language & Region' },
    ],
  },
  {
    heading: 'NOTIFICATIONS',
    items: [
      { id: 'email-notif', label: 'Email' },
      { id: 'push-notif', label: 'Push Notifications' },
    ],
  },
  {
    heading: 'SECURITY',
    items: [
      { id: 'password', label: 'Password' },
      { id: '2fa', label: 'Two-Factor Auth' },
      { id: 'sessions', label: 'Active Sessions' },
    ],
  },
  {
    heading: 'BILLING',
    items: [
      { id: 'plans', label: 'Plans' },
      { id: 'payment', label: 'Payment Methods' },
      { id: 'invoices', label: 'Invoices' },
    ],
  },
]
</script>

<template>
  <div class="flex flex-col h-screen bg-gray-50 pl-16">

    <!-- SIDE NAV: fixed, 64px wide, full height -->
    <nav class="fixed left-0 top-0 w-16 h-screen bg-gray-900 flex flex-col items-center py-4 z-10">
      <div class="w-8 h-8 bg-gray-600 rounded mb-6 flex items-center justify-center text-xs text-gray-400">L</div>
      <div class="flex flex-col items-center gap-2 flex-1">
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-700 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-300 rounded-sm" />
        </div>
      </div>
      <div class="w-8 h-8 rounded-full bg-gray-500 flex items-center justify-center text-xs text-gray-300">U</div>
    </nav>

<div class="flex flex-1 overflow-hidden">
      <!-- SETTINGS SIDEBAR -->
      <aside class="w-56 bg-white border-r border-gray-200 overflow-y-auto shrink-0">
        <div class="p-4 space-y-5">
          <div v-for="section in navSections" :key="section.heading">
            <p class="text-xs font-bold tracking-widest text-gray-400 px-3 mb-1">{{ section.heading }}</p>
            <div class="space-y-0.5">
              <button
                v-for="item in section.items"
                :key="item.id"
                class="w-full text-left px-3 py-1.5 text-sm rounded transition-colors"
                :class="activeSection === item.id
                  ? 'bg-gray-100 text-gray-900 font-medium border-l-2 border-gray-800'
                  : 'text-gray-500 hover:bg-gray-50'"
                @click="activeSection = item.id"
              >
                {{ item.label }}
              </button>
            </div>
          </div>
        </div>
      </aside>

      <!-- SETTINGS CONTENT -->
      <main class="flex-1 overflow-y-auto p-6">
        <div class="max-w-2xl space-y-6">
          <div>
            <h1 class="text-xl font-semibold text-gray-900">ACCOUNT SETTINGS</h1>
            <p class="text-sm text-gray-400 mt-1">Manage your account information and preferences.</p>
          </div>

          <!-- PROFILE PHOTO -->
          <Card>
            <CardHeader class="pb-2">
              <p class="text-xs font-bold tracking-widest text-gray-400">PROFILE PHOTO</p>
            </CardHeader>
            <CardContent class="flex items-center gap-4">
              <Avatar class="w-16 h-16">
                <AvatarFallback class="bg-gray-200 text-gray-500 text-xl">UN</AvatarFallback>
              </Avatar>
              <div class="space-y-1">
                <Button variant="outline" class="h-8 text-xs">Change Photo</Button>
                <p class="text-xs text-gray-400">JPG, PNG, GIF up to 5MB</p>
              </div>
            </CardContent>
          </Card>

          <!-- PERSONAL INFORMATION -->
          <Card>
            <CardHeader class="pb-2">
              <p class="text-xs font-bold tracking-widest text-gray-400">PERSONAL INFORMATION</p>
            </CardHeader>
            <CardContent class="space-y-4">
              <div class="space-y-1.5">
                <Label class="text-sm text-gray-700">Full Name</Label>
                <Input value="USER FULL NAME" />
              </div>
              <div class="space-y-1.5">
                <Label class="text-sm text-gray-700">Email Address</Label>
                <Input value="user@example.com" />
                <p class="text-xs text-gray-400">Email is verified. <a href="#" class="underline">Change email</a></p>
              </div>
              <div class="space-y-1.5">
                <Label class="text-sm text-gray-700">Username</Label>
                <div class="flex">
                  <span class="inline-flex items-center px-3 border border-r-0 border-gray-300 bg-gray-50 text-gray-500 text-sm rounded-l">@</span>
                  <Input value="username" class="rounded-l-none" />
                </div>
              </div>
            </CardContent>
            <Separator />
            <CardFooter class="flex justify-end gap-3 pt-4">
              <Button variant="outline">Cancel</Button>
              <Button>Save Changes</Button>
            </CardFooter>
          </Card>

          <!-- DANGER ZONE -->
          <Card class="border border-gray-400">
            <CardHeader class="pb-2">
              <p class="text-xs font-bold tracking-widest text-gray-500">DANGER ZONE</p>
            </CardHeader>
            <CardContent class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-700">Delete Account</p>
                <p class="text-xs text-gray-400 mt-0.5">Permanently delete your account and all associated data.</p>
              </div>
              <Button variant="outline" class="border-gray-800 text-gray-800 hover:bg-gray-100 shrink-0 ml-4">
                Delete Account
              </Button>
            </CardContent>
          </Card>

        </div>
      </main>
    </div>
  </div>
</template>
