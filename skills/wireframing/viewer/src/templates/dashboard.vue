<script setup>
import { Card, CardHeader, CardContent, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

const stats = [
  { label: 'TOTAL USERS', value: '12,340', change: '+4.2%' },
  { label: 'ACTIVE TODAY', value: '1,892', change: '+1.1%' },
  { label: 'REVENUE', value: '$48,200', change: '+8.7%' },
  { label: 'CONVERSION', value: '3.4%', change: '-0.3%' },
]

const activities = [
  { id: '001', description: 'USER ACTION PLACEHOLDER', user: 'USER NAME', time: '2 min ago', status: 'Active' },
  { id: '002', description: 'USER ACTION PLACEHOLDER', user: 'USER NAME', time: '15 min ago', status: 'Pending' },
  { id: '003', description: 'USER ACTION PLACEHOLDER', user: 'USER NAME', time: '1 hr ago', status: 'Active' },
  { id: '004', description: 'USER ACTION PLACEHOLDER', user: 'USER NAME', time: '3 hr ago', status: 'Inactive' },
  { id: '005', description: 'USER ACTION PLACEHOLDER', user: 'USER NAME', time: 'Yesterday', status: 'Active' },
]

const navItems = ['OVERVIEW', 'ANALYTICS', 'REPORTS', 'USERS', 'SETTINGS']
</script>

<template>
  <div class="flex flex-col h-screen bg-gray-50 pl-16">

    <!-- SIDE NAV: fixed, 64px wide, full height -->
    <nav class="fixed left-0 top-0 w-16 h-screen bg-gray-900 flex flex-col items-center py-4 z-10">
      <div class="w-8 h-8 bg-gray-600 rounded mb-6 flex items-center justify-center text-xs text-gray-400">L</div>
      <div class="flex flex-col items-center gap-2 flex-1">
        <div class="w-10 h-10 rounded-lg bg-gray-700 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-300 rounded-sm" />
        </div>
        <div class="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
          <div class="w-5 h-5 bg-gray-500 rounded-sm" />
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

<div class="flex flex-1 overflow-hidden">
      <!-- SIDEBAR -->
      <aside class="w-56 bg-white border-r border-gray-200 flex flex-col shrink-0">
        <div class="p-4 space-y-1">
          <p class="text-xs font-bold tracking-widest text-gray-400 px-3 mb-3">NAVIGATION</p>
          <Button
            v-for="(item, i) in navItems"
            :key="item"
            variant="ghost"
            :class="['w-full justify-start text-sm', i === 0 ? 'bg-gray-100 text-gray-900 font-medium' : 'text-gray-500']"
          >
            <div class="w-4 h-4 bg-gray-300 rounded-sm mr-2 shrink-0" />
            {{ item }}
          </Button>
        </div>
      </aside>

      <!-- MAIN CONTENT -->
      <main class="flex-1 overflow-y-auto p-6 space-y-6">
        <div>
          <h1 class="text-xl font-semibold text-gray-900">DASHBOARD</h1>
          <p class="text-sm text-gray-400 mt-0.5">OVERVIEW DESCRIPTION PLACEHOLDER</p>
        </div>

        <!-- STAT CARDS -->
        <div class="grid grid-cols-4 gap-4">
          <Card v-for="stat in stats" :key="stat.label">
            <CardContent class="pt-4 pb-4">
              <p class="text-xs font-bold tracking-widest text-gray-400">{{ stat.label }}</p>
              <p class="text-2xl font-semibold text-gray-900 mt-1">{{ stat.value }}</p>
              <p class="text-xs text-gray-400 mt-1">{{ stat.change }} vs last period</p>
            </CardContent>
          </Card>
        </div>

        <!-- CHARTS -->
        <div class="grid grid-cols-2 gap-4">
          <Card>
            <CardHeader class="pb-2">
              <CardTitle class="text-sm font-semibold text-gray-700">CHART AREA — BAR CHART</CardTitle>
            </CardHeader>
            <CardContent>
              <div class="h-40 border border-dashed border-gray-300 rounded flex items-center justify-center">
                <span class="text-sm text-gray-400">CHART PLACEHOLDER</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader class="pb-2">
              <CardTitle class="text-sm font-semibold text-gray-700">CHART AREA — DONUT CHART</CardTitle>
            </CardHeader>
            <CardContent>
              <div class="h-40 border border-dashed border-gray-300 rounded flex items-center justify-center">
                <span class="text-sm text-gray-400">CHART PLACEHOLDER</span>
              </div>
            </CardContent>
          </Card>
        </div>

        <!-- ACTIVITY TABLE -->
        <Card>
          <CardHeader class="pb-2">
            <div class="flex items-center justify-between">
              <CardTitle class="text-sm font-semibold text-gray-700">RECENT ACTIVITY</CardTitle>
              <Button variant="ghost" class="text-xs text-gray-400 h-7">View all</Button>
            </div>
          </CardHeader>
          <CardContent class="p-0">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead class="text-xs">ID</TableHead>
                  <TableHead class="text-xs">DESCRIPTION</TableHead>
                  <TableHead class="text-xs">USER</TableHead>
                  <TableHead class="text-xs">TIME</TableHead>
                  <TableHead class="text-xs">STATUS</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="row in activities" :key="row.id">
                  <TableCell class="text-xs text-gray-500">{{ row.id }}</TableCell>
                  <TableCell class="text-xs text-gray-700">{{ row.description }}</TableCell>
                  <TableCell class="text-xs text-gray-500">{{ row.user }}</TableCell>
                  <TableCell class="text-xs text-gray-400">{{ row.time }}</TableCell>
                  <TableCell>
                    <Badge variant="outline" class="text-xs text-gray-600 border-gray-300">{{ row.status }}</Badge>
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </main>
    </div>
  </div>
</template>
