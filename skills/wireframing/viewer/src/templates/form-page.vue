<script setup>
import { Card, CardContent, CardHeader, CardFooter } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Checkbox } from '@/components/ui/checkbox'
import { Separator } from '@/components/ui/separator'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
</script>

<template>
  <div class="flex flex-col min-h-screen bg-gray-50 pl-16">

    <!-- SIDE NAV: fixed, 64px wide, full height -->
    <nav class="fixed left-0 top-0 w-16 h-screen bg-gray-900 flex flex-col items-center py-4 z-10">
      <div class="w-8 h-8 bg-gray-600 rounded mb-6 flex items-center justify-center text-xs text-gray-400">L</div>
      <div class="flex flex-col items-center gap-2 flex-1">
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-700 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-300 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
        </div>
      </div>
      <div class="w-8 h-8 rounded-full bg-gray-500 flex items-center justify-center text-xs text-gray-300">U</div>
    </nav>


    <main class="flex-1 py-8 px-4">
      <div class="max-w-2xl mx-auto space-y-6">
        <!-- Page title -->
        <div>
          <h1 class="text-xl font-semibold text-gray-900">PAGE TITLE</h1>
          <p class="text-sm text-gray-400 mt-1">FORM PAGE DESCRIPTION PLACEHOLDER</p>
        </div>

        <Card>
          <!-- Section 1: Basic Information -->
          <CardHeader class="pb-2">
            <p class="text-xs font-bold tracking-widest text-gray-400">BASIC INFORMATION</p>
          </CardHeader>
          <CardContent class="space-y-4">
            <div class="space-y-1.5">
              <Label class="text-sm text-gray-700">FIELD LABEL ONE</Label>
              <Input placeholder="PLACEHOLDER TEXT" />
              <p class="text-xs text-gray-400">Helper text for this field goes here.</p>
            </div>
            <div class="space-y-1.5">
              <Label class="text-sm text-gray-700">FIELD LABEL TWO</Label>
              <Input placeholder="PLACEHOLDER TEXT" />
              <p class="text-xs text-gray-400">Helper text for this field goes here.</p>
            </div>
          </CardContent>

          <Separator />

          <!-- Section 2: Details -->
          <CardHeader class="pb-2 pt-4">
            <p class="text-xs font-bold tracking-widest text-gray-400">DETAILS</p>
          </CardHeader>
          <CardContent class="space-y-4">
            <div class="space-y-1.5">
              <Label class="text-sm text-gray-700">TEXTAREA LABEL</Label>
              <Textarea placeholder="PLACEHOLDER TEXT" class="resize-none h-24" />
              <p class="text-xs text-gray-400">Helper text for this field goes here.</p>
            </div>
            <div class="space-y-1.5">
              <Label class="text-sm text-gray-700">SELECT LABEL</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="SELECT AN OPTION" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="option1">OPTION ONE</SelectItem>
                  <SelectItem value="option2">OPTION TWO</SelectItem>
                  <SelectItem value="option3">OPTION THREE</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </CardContent>

          <Separator />

          <!-- Section 3: Preferences -->
          <CardHeader class="pb-2 pt-4">
            <p class="text-xs font-bold tracking-widest text-gray-400">PREFERENCES</p>
          </CardHeader>
          <CardContent class="space-y-3">
            <div v-for="i in 3" :key="i" class="flex items-start gap-3">
              <Checkbox :id="`pref-${i}`" class="mt-0.5" />
              <div>
                <Label :for="`pref-${i}`" class="text-sm text-gray-700 cursor-pointer">PREFERENCE OPTION {{ i }}</Label>
                <p class="text-xs text-gray-400 mt-0.5">Description of what this preference controls.</p>
              </div>
            </div>
          </CardContent>

          <Separator />

          <!-- Actions -->
          <CardFooter class="flex justify-end gap-3 pt-4">
            <Button variant="outline">Cancel</Button>
            <Button>Save Changes</Button>
          </CardFooter>
        </Card>
      </div>
    </main>
  </div>
</template>
